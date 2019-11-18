/*

  Copyright 2018 Wanchain Foundation.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

//                            _           _           _
//  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
//  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
//   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
//    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
//

pragma solidity ^0.4.24;

import "../interfaces/ITokenManager.sol";
import "../interfaces/IHTLC.sol";

contract StoremanGroupStorage {
    /// token manager instance address
    ITokenManager public tokenManager;
    /// quotaLedger(HTLC) instance address
    IHTLC public quotaLedger;
    bool public isWhiteListEnabled;

    /// tokenOrigAddr->storemanPK->StoremanGroup)
    mapping(bytes=>mapping(bytes => StoremanGroup)) internal storemanGroupMap;
    /// storemanPK->isEnabled
    mapping(bytes=>bool) internal mapSmgWhiteList;

    struct StoremanGroup {
        uint    deposit;                  /// the storeman group deposit in wan coins
        uint    unregisterApplyTime;      /// the time point for storeman group applied unregistration
        uint    txFeeRatio;               /// the fee ratio required by storeman group
        uint    startBlockNumber;         /// the start block number for bonus calculation for storeman group
        address initiator;                /// the account for registering a storeman group which provides storeman group deposit
    }
}