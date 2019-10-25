Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7E3CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 09:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D880421D7B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 09:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="MPszKsCs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438409AbfJYJZA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:25:00 -0400
Received: from mail-eopbgr780070.outbound.protection.outlook.com ([40.107.78.70]:59294
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726350AbfJYJZA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 05:25:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/aQDzRWWIdhydlb10pVEnuM3ywdM5UL9EmvtuicMHorsSxZ2ICrqVVDQNmu2Z/02fXmA0wyC9rlNhGOMYSSihezc7Ws4i3CDVFErQKwgIfW2KVSVBG0536wPXuoxQ35phu/0OcXoYX61aZ1TZj5G+NregftcG4ktzYzKWGV2lY2kGC1r7jk2l5b6SmqKdwvIpqhsAbxKrPMQu1KoYtW+fKWXa/wpq6RoZyNrPvRVkK6JIM174Pvb7JikTZsTrhhzV5rk9J/zHCrPkghYfC9b4CE59oQ8cv/LIffZufotoMZCvTbekNXoOD/Dc4toSySDGt2wa5r6dVn/rbqHOGLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRVl1lEqGaOzfb8uti06rW/uFH6hGZJ9crE6rUI0s2Y=;
 b=njOT0K7Y2DXCdpxGZf+BmJiaLgOA894NHJwuL99W7E9bLGdlbn2PkmnPeplfpoZiwLPsla5LvqAejK5upsyWIGOC6ntIDgT1iW4Yg0xUkSjgOItxTU4ess0jIMC/my6xqQcRME5UUbnHwF5UKBpVHoQjjdRoUBxVLcN1Zgr/UTg23Fl68ZAE1FAm+agEEUaKbWjaAbVYFBnxsa7tHjPe2jmjUP5cUDFPqvBcgjMiVO/jE7J/r4bD8GfcBQVjfLS1mbYtmNrMaPHMwOALFlaWcnoAYdjALGZWSPM8uXcXr9jy5Jwc5hVDYp9UXb8H8svYh+ML4jxVFqTkN/fZ3H4tcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRVl1lEqGaOzfb8uti06rW/uFH6hGZJ9crE6rUI0s2Y=;
 b=MPszKsCsvnYYzkhS/vfPyvXLANYRc0kitnGctkxZPTibhGBVroQE0Qp9h1ic2U2XOa1bc/m2SSqusCIum7zOzx95j0siovMLRiqztmN0dPhVg5jhmFZFKLYBBUpBDjBKsp6V6hpgpggcshxhMrWrVrROLRbsj/Oj7LLtDTx83h8=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB4784.namprd05.prod.outlook.com (52.135.115.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.17; Fri, 25 Oct 2019 09:24:57 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::6d27:968b:14e5:aa54]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::6d27:968b:14e5:aa54%7]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 09:24:57 +0000
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v12 1/9] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Thread-Topic: [PATCH v12 1/9] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Thread-Index: AQHVXX6v4X5eR8Ol4kmPo5xi66vx3adnMgeAgAQ/CQA=
Date:   Fri, 25 Oct 2019 09:24:56 +0000
Message-ID: <CACqStodH0c_3FuH5L64ywid1coRE90H6gEGJr6uA03nxh1D15A@mail.gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
 <20190828085746.26231-2-tz.stoyanov@gmail.com>
 <20191022123401.4e2b1ab6@gandalf.local.home>
In-Reply-To: <20191022123401.4e2b1ab6@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0014.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::27) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAW8XwUvLRrzvKzjokcu50cGOqXNVXLcqrT9FURXXk3h652sWM4m
        zfAsfQbgLfrkU24oRAX9kLf7XJ2niKTTU6RIE/U=
x-google-smtp-source: APXvYqz2aFbvfx2YA+YuvZcLpdOgF91pCManxd010Mv+G/ur5xIR9ySuDCUStlQOFWTR9rMzN3LcKwUP26CANbipboo=
x-received: by 2002:a5d:6a03:: with SMTP id m3mr1901877wru.90.1571995491659;
 Fri, 25 Oct 2019 02:24:51 -0700 (PDT)
x-gmail-original-message-id: <CACqStodH0c_3FuH5L64ywid1coRE90H6gEGJr6uA03nxh1D15A@mail.gmail.com>
x-originating-ip: [209.85.221.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17e32b7c-1b5d-41fd-a83a-08d7592d334a
x-ms-traffictypediagnostic: SN6PR05MB4784:
x-microsoft-antispam-prvs: <SN6PR05MB4784F800245D404CA268E2AEDC650@SN6PR05MB4784.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(199004)(189003)(6506007)(81156014)(99286004)(53546011)(446003)(81166006)(386003)(476003)(102836004)(486006)(11346002)(66556008)(316002)(8936002)(54906003)(64756008)(25786009)(256004)(95326003)(26005)(86362001)(52116002)(55446002)(8676002)(5660300002)(71190400001)(478600001)(4744005)(66446008)(4326008)(305945005)(498394004)(186003)(6486002)(76176011)(71200400001)(6436002)(61266001)(9686003)(3846002)(66946007)(6512007)(66066001)(6862004)(6116002)(2906002)(66476007)(14454004)(229853002)(7736002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4784;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7zdQseVoUqlvhWrKVcsz/KH6gjZEYuYh7SUbh8n1WKPuuycHjJI/echG6BT6EeVKl2KFyx0YjKL5rle6wQ9/JL2mx9AXtZnnDMPUXTk+Hrr38thWVaBWWJlfVEeZ53y+3IHajCSSmLitREgzHoJ4d37ZurWl3KQrXgYfD0/rJX4b4Sz7voa6VMGLKGZ+L99L1BWJMvFspT1dKe4+bDjvgyuxf7MhKOTkC7fZLjwPLePHMaLLXQ5EpOL5ilEBqIssrplx/Pb8ButJCKz5RnyJFbxusIGvPiH+Q6DzlagCulftp+ASjoQ1CmXNjHKMXEa8uEwjVz1tv7a4C3aCj7572GtCaEeDZRqrjh1TrhU6ef7LPJ/ezsipaDaHOVCqglx75jJFSTQmVmTkzw42J1AY+ojPXzysTfprmMOR3Me6bb3GOpJ6UbZHNutikj/HuO1R
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <189FB64B7BED094B9F4B5B027BEF399A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e32b7c-1b5d-41fd-a83a-08d7592d334a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 09:24:56.6734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gkqrpeWkucftq4bpPxefT92+PB/+OfZY4uzQ2LERisNO2CEn8dvyIpDFR/pDhPE3beEzPYn0wrUI2V4sPWH8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4784
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCBPY3QgMjIsIDIwMTkgYXQgNzozNCBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQouLi4NCj4gPiArew0KPiA+ICsgICAgIHJldHVybiB0cmFjZWNt
ZF9maWxsX2xvY2FsX2V2ZW50c19zeXN0ZW0odHJhY2luZ19kaXIsIHBldmVudCwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE5VTEwsIHBhcnNpbmdf
ZmFpbHVyZXMpOw0KPg0KPiBXb24ndCB0aGlzIHJldHVybiBubyBldmVudHM/DQo+DQo+IC0tIFN0
ZXZlDQo+DQpMb29rcyBsaWtlIGl0IHdpbGwgcmV0dXJuIG5vIGV2ZW50cywgSSdsbCByZXZpZXcg
dGhlIGxvZ2ljIGFuZCB0aGUgcGF0Y2guDQoNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoqDQo+ID4g
ICAqIHRyYWNlY21kX2xvY2FsX3BsdWdpbnMgLSByZXR1cm5zIGFuIGFycmF5IG9mIGF2YWlsYWJs
ZSB0cmFjZXIgcGx1Z2lucw0KPiA+ICAgKiBAdHJhY2luZ19kaXI6IFRoZSBkaXJlY3RvcnkgdGhh
dCBjb250YWlucyB0aGUgdHJhY2luZyBkaXJlY3RvcnkNCj4NCg0KDQotLSANClR6dmV0b21pciAo
Q2VjbykgU3RveWFub3YNClZNd2FyZSBPcGVuIFNvdXJjZSBUZWNobm9sb2d5IENlbnRlcg0K
