pragma solidity >=0.4.22 <0.7.0;
//pragma experimental ABIEncoderV2;

contract VASPPlatform {
    struct ShareVASPProperty {
        bool status;
        string vcode;
        string ctrycode;
    }
    
    struct BLProperty {
        string S_name;
        string S_DOB;
        string S_ctry;
        address S_addr;
        bool Enabled_flag;
        uint Update_Date;
    }
    
    address regulatoryAuthority;
    /*VASP*/
    mapping(string => mapping(string =>address)) VASPInfo;
    mapping(string => mapping(string => ShareVASPProperty)) shareVASP;
    /*blacklist*/
    mapping(string => mapping(string =>address)) BlacklistInfo;
    mapping(address => BLProperty) shareBL; /*有問題待解決*/
    
    event BlacklistShared(
        string S_name,
        string S_DOB,
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
    function addBlacklist(
        string memory _Sname,
        string memory _Sctry,
        string memory _DOB,
        address _Saddr
    ) public {
        require(
            msg.sender == regulatoryAuthority, /*需要是政府來建立黑名單*/
            "You are not a regulator，[_VASPAddress] Error."
        );
        uint256 update_time = now;
        
        BlacklistInfo[_Sname][_Sctry] = address(_Saddr);
        shareBL[_Saddr]=BLProperty(_Sname,_Sctry,_DOB,_Saddr,true,update_time);
        emit BlacklistShared(
            _Sname,
            _Sctry,
            _DOB,
            _Saddr,
            true,
            update_time
            );
    }
    function getBL(
        string memory _Vcode, string memory _Vctry, address _Saddr) public view returns (string memory, bool) {
         require(
            VASPInfo[_Vcode][_Vctry]==msg.sender ,
            "You are not a VASP，[_Vcode] Error."
         );
        return (shareBL[_Saddr].S_name,shareBL[_Saddr].Enabled_flag);  /*有問題待解決*/
        }
    function delBlacklist(
        address _Saddr
    ) public {
        require(
            msg.sender == regulatoryAuthority, /*需要是政府來建立黑名單*/
            "You are not a regulator，[_VASPAddress] Error."
        );
        shareBL[_Saddr].Enabled_flag = false;
        shareBL[_Saddr].Update_Date = now;

        emit BlacklistShared(
            shareBL[_Saddr].S_name,
            shareBL[_Saddr].S_ctry,
            shareBL[_Saddr].S_DOB,
            shareBL[_Saddr].S_addr,
            shareBL[_Saddr].Enabled_flag,
            shareBL[_Saddr].Update_Date
            );
    }    
}


