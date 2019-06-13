Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B0FC31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 14:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 789AB207E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 14:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="e3M6NKMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbfFMO7i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 10:59:38 -0400
Received: from mail-eopbgr710079.outbound.protection.outlook.com ([40.107.71.79]:29888
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732602AbfFMOvv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 10:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JKphRTakOuozvraBZ/s2XdmvTjazpNc+W2Ng6VjQso=;
 b=e3M6NKMb3UfMpLYhDNnchzhazL4MdUDcn4lNGGQCXZ9mpi2lJBKS14ISbN5xG9eiX7Oy+/epVYJ+rTp6Abjo5Ly3i1IbHh+d/J83tLQa1OGzCLyFOR6WkHBjosJr5CcFt6Ry+pVcUnYZVj+iMaSjB8IpYKrwWdvo6Yb8c9/YiVQ=
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com (10.167.163.156) by
 MWHPR0501MB3803.namprd05.prod.outlook.com (10.167.163.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.5; Thu, 13 Jun 2019 14:51:48 +0000
Received: from MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::4b8:7531:ae2c:4293]) by MWHPR0501MB3772.namprd05.prod.outlook.com
 ([fe80::4b8:7531:ae2c:4293%3]) with mapi id 15.20.2008.006; Thu, 13 Jun 2019
 14:51:48 +0000
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/3] trace-cmd: Fix some bugs that include issues with
 --max-graph-depth
Thread-Topic: [PATCH 0/3] trace-cmd: Fix some bugs that include issues with
 --max-graph-depth
Thread-Index: AQHVIfeGIKSE/2VjpE+3jbLR7GCgLQ==
Date:   Thu, 13 Jun 2019 14:51:47 +0000
Message-ID: <CAE0o1NuCo-vhX9j6G_OnYi=UwMETv+eH=881z1oryzJ_6=JKuQ@mail.gmail.com>
References: <20190612181927.608151291@goodmis.org>
In-Reply-To: <20190612181927.608151291@goodmis.org>
Reply-To: "slavomir.kaslev@gmail.com" <slavomir.kaslev@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR17CA0053.namprd17.prod.outlook.com
 (2603:10b6:3:13f::15) To MWHPR0501MB3772.namprd05.prod.outlook.com
 (2603:10b6:301:7a::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaslevs@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVH1D/SlTvsnw0bjqF+GK2Jx7rIQeBVNgUWIKrsN/zd8nBqt41y
        MNzBT4LoCXcnBCBJd29Iv6UFfeimb499MJaY7g==
x-google-smtp-source: APXvYqzpePZ7R/jZ7fCeLLvPXVLta7ZDw+AvcKLyrOWrYh9Ja0G4l/xbOmWvYNW+r12MdRNgWNnReBxi4DuTQucUPqY=
x-received: by 2002:a02:ce37:: with SMTP id v23mr58708327jar.2.1560437504301;
 Thu, 13 Jun 2019 07:51:44 -0700 (PDT)
x-gmail-original-message-id: <CAE0o1NuCo-vhX9j6G_OnYi=UwMETv+eH=881z1oryzJ_6=JKuQ@mail.gmail.com>
x-originating-ip: [209.85.166.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0356fcd7-cd3d-4df6-b1cc-08d6f00ea917
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR0501MB3803;
x-ms-traffictypediagnostic: MWHPR0501MB3803:
x-microsoft-antispam-prvs: <MWHPR0501MB3803C2AFB149F8F305DBDC5BDAEF0@MWHPR0501MB3803.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(346002)(39860400002)(396003)(199004)(189003)(305945005)(14454004)(99286004)(7736002)(66446008)(22416003)(52116002)(316002)(6436002)(2906002)(76176011)(71190400001)(43066004)(66066001)(73956011)(66946007)(64756008)(66556008)(66476007)(3846002)(498394004)(102836004)(61726006)(11346002)(6116002)(2860700004)(446003)(229853002)(95326003)(86362001)(478600001)(71200400001)(61266001)(6246003)(8796002)(8936002)(81166006)(81156014)(8676002)(9686003)(486006)(6512007)(476003)(25786009)(53936002)(186003)(55446002)(5660300002)(386003)(53546011)(6506007)(6486002)(256004)(68736007)(66806009)(26005)(6862004)(4744005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0501MB3803;H:MWHPR0501MB3772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OU5zw+wOTFqbsuab+0VyOzEyICOIzFvL4eGPsuDaU7y1cHz0JMpoU6nTTHevuNL0umtk1SVBgjFIHxSixCVL+kXg+NEf/5fHhXa6DxYGk6Gn9f9gOvdyjCHetiaCXemlj8fYldG7XxzJiUwCiI7hwsr38bkOCH20C7Qg7alpM3UccBLKmh1dVFdQtcfP2rKWXS/RQuEuP6RqqM3lov7qbzhiFp44y63O8hAIeY0HxJ4s4Jwsmc3QEBzXkc4iqn/dgOAqtzg0bglB4O050EWiVwLGV+NNzlCTJuJW+Og4Wfyzms38QqctkBtXi4ZxSprfOWVe5voXkUjOo41qiL8SiIMmVA575euQGU8VeO88qpMXhZgBIUEipIPs2WECg4HrNw7dD/smp+TPN3QYqhrx1B1Tgyfn0PqU5qqxCR6cEWU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B2B8E6B511AE94694940C206463CF74@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0356fcd7-cd3d-4df6-b1cc-08d6f00ea917
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:51:47.9752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaslevs@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3803
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gV2VkLCBKdW4gMTIsIDIwMTkgYXQgOToyMSBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+DQo+IFNvbWUgbGFzdCBtaW51dGUgYnVncyB0aGF0IHdl
cmUgZm91bmQgYW5kIGZpeGVkLg0KPg0KPiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSAoMyk6DQo+
ICAgICAgIHRyYWNlLWNtZDogRml4IHR5cG8gaW4gTWFrZWZpbGUgYmlkciB0byBiZGlyDQo+ICAg
ICAgIHRyYWNlLWNtZDogSGF2ZSAtLW1heC1ncmFwaC1kZXB0aCBvbmx5IGJlIHBhcnQgb2YgaW5z
dGFuY2UNCj4gICAgICAgdHJhY2UtY21kOiBDaGVjayB0aGUgcmV0dXJuIG9mIGdldF9maWxlX2Nv
bnRlbnQoKSBiZWZvcmUgY2FsbGluZyBhZGRfcmVzZXRfZmlsZSgpDQo+DQo+IC0tLS0NCj4gIHRy
YWNlY21kL01ha2VmaWxlICAgICAgICAgICAgICB8ICAyICstDQo+ICB0cmFjZWNtZC9pbmNsdWRl
L3RyYWNlLWxvY2FsLmggfCAgMiArKw0KPiAgdHJhY2VjbWQvdHJhY2UtcmVjb3JkLmMgICAgICAg
IHwgMzMgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDIyIGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KDQpMb29rcyBnb29kIHRvIG1l
Lg0KDQpSZXZpZXdlZC1ieTogU2xhdm9taXIgS2FzbGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQoN
CkNoZWVycywNCg0KLS1TbGF2aQ0K
