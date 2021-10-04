pragma solidity >=0.4.22 <0.7.0;
//pragma experimental ABIEncoderV2;

contract VASPPlatform {
    struct ShareVASPProperty {
        bool status;
        string vcode;
        string ctrycode;
    }
    address regulatoryAuthority;
    
    mapping(string => mapping(string =>address)) VASPInfo;
    mapping(string => mapping(string => ShareVASPProperty)) shareVASP;
    /*blacklist*/
    mapping(string => mapping(string =>address)) BlacklistInfo;
    
    event BlacklistShared(
        string S_name,
        string S_ctry,
        address S_addr,
        bool Enabled_flag,
        uint256 time
    );
    
    constructor() public {
        regulatoryAuthority = msg.sender;
    }
    
    /*政府建立VASP*/
    function registerVASP(
        string memory _vcode,
        string memory _ctrycode,
        address _VASPAddress
    ) public {
        require(
            msg.sender == regulatoryAuthority,
            "You are not a government，[_ctrycode] Error."
        );
        VASPInfo[_vcode][_ctrycode] = address(_VASPAddress);
        shareVASP[_vcode][_ctrycode].status = true;

    }
    
    function getVASP(string memory _vcode, string memory _ctrycode) public view returns (bool) {
        return shareVASP[_vcode][_ctrycode].status;
    }
    function getVASPaddr(string memory _vcode, string memory _ctrycode) public view returns (address) {
        //return shareVASP[_vcode][_ctrycode].status;
        return VASPInfo[_vcode][_ctrycode];
    }
    /*政府取消VASP*/
    function cancelVASP(
        string memory _vcode,
        string memory _ctrycode,
        address _VASPAddress
    ) public {
        require(
            msg.sender == regulatoryAuthority, /*需要是政府來取消*/
            "You are not a regulator，[_VASPAddress] Error."
        );
        VASPInfo[_vcode][_ctrycode] = address(_VASPAddress);
        shareVASP[_vcode][_ctrycode].status = false;

    }
    function updateBlacklist(
        string memory _Sname,
        string memory _Sctry,
        address _Saddr
    ) public {
        require(
            msg.sender == regulatoryAuthority, /*需要是政府來建立黑名單*/
            "You are not a regulator，[_VASPAddress] Error."
        );
        BlacklistInfo[_Sname][_Sctry] = address(_Saddr);
        emit BlacklistShared(
            _Sname,
            _Sctry,
            _Saddr,
            true,
            now
            );
    }
}

