#include "include/Schnorr.verification.hpp"

ACTION verifier::verify(name from, string randomPoint, string signature, string groupKey, string raw_msg, string memo)
{   
    require_auth(from);

    const char *groupKeyX = (groupKey.substr(2, 64)).c_str();
    const char *groupKeyY = (groupKey.substr(66, 64)).c_str();
    const char *randomPointX = (randomPoint.substr(2, 64)).c_str();
    const char *randomPointY = (randomPoint.substr(66, 64)).c_str();
    
    bcl::CurvePoint R(randomPointX, randomPointY);
    bcl::CurvePoint PK(groupKeyX, groupKeyY);

    check(R.isOnCurve(), "Random point is not on curve");
    check(PK.isOnCurve(), "PK is not on curve");

    // inner hash
    // Bytes raw_msg_bytes = from_hex((const char*)raw_msg.c_str());
    // checksum256 hashed = sha256((const char*)raw_msg_bytes.data(), raw_msg_bytes.size());
    checksum256 hashed = sha256((const char*)raw_msg.data(), raw_msg.size());
    string message = to_hex(hashed);
    // print("message: ", message);

    // outer hash
    const string hash_input = message + randomPoint;
    Bytes hash_input_bytes = from_hex((const char*)hash_input.c_str());
    checksum256 m = sha256((const char*)hash_input_bytes.data(), hash_input_bytes.size());
    string result = to_hex(m);
    
    // left side: s*G
    CurvePoint left = CurvePoint::G;
    left.multiply(Uint256(signature.c_str()));
    left.normalize();
    check(left.isOnCurve(), "Left result is not on curve");

    // right side: R + m*PK
    // m*PK
    PK.multiply(Uint256(result.c_str()));
    PK.normalize();

    // R + m*PK
    PK.add(R);
    PK.normalize();

    CurvePoint right = PK;
    check(right.isOnCurve(), "Right result is not on curve");

    bool ret = left == right;
    check(ret, "Invalid signature");

    // print(ret);

    require_recipient(from);

    // return ret;
}
