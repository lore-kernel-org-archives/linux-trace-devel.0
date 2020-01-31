Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24347C33CB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 09:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC381206F0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 09:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="Ef0Xddjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgAaJxp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 04:53:45 -0500
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:6774
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728160AbgAaJxp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 04:53:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Axqt28wngFuSCx0IVz6PyWk6KuKPmPvPMPkQ6IlmdsGjUxQu/XJDCm3GuNTK66LM01D6tGi4pwWNRX/zWeNSeqJm1c6reyfM+yQqVAKkaS2g4RUwLrXvMp7hLieJZyxKcGss50UiZONauXuFqfaVsB2NMszH+IcxIVwzeAMswLMhWW86irc4MA+hqDkxezxpi7mlIsbClIXMz+5KEDiT1lW83Kk5i2TBJgl6n2nOL0/Z/14ZYnmyf3TTHp8C01OnqzJEBaDczresP6r9Ffg+I0J0o0FBaMI/pJvayAA3yDH+ht0t4r1P8T7/cM1E37FLe+/BP3XYO5fALg/X578pTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDT2afrG1j9sd8S3T9uvpXMi/FqZrGmpY2V/ya0XQLA=;
 b=IFhHKoXI3hkk/C574y0+oWniIc1BD9YdEabLcmCfAqJnkimN06mBT+cM+uIKHPcUEuHB01Umg35gOWXrJ5OXhiTmhNOsDLRgmhjItBvMR/+x8dPegA4l2v2XR87OHcUSw9WZw7F+tN7PqVwOtbbGd1o/pmQpOV0DNaCRL08v8p7jPQzZShGtVVhKCYVrP55Doxe8m6h5Ciu88wdsPElLFrkXiNry5IBw5nFV+9UvU8/DgBVVyukymrIajoEyaczUGvyVbKngwxJkGDyeTflrlysb244Unq6aeI7mtdsUkUTPbbEW5oLpqoCorDsrYKTu8qiQq6U8mKjBCIFTPdsrnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDT2afrG1j9sd8S3T9uvpXMi/FqZrGmpY2V/ya0XQLA=;
 b=Ef0XddjcCDBt2c+F9qZA8o4YVJWwwYX1vT2jY74KgunAmxN3ZW7pGUEZTKU5Ft2lHESqRQ9JJCyzSz4Z441dUqwt1ZoxsBP1iYaxIlnku1SRDS6LKU9tq4mF4NlQnFHfznveI1lL70jGUUhQwiL0PY2q4cXRf/ghrOwN7EfmxQk=
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB4000.namprd05.prod.outlook.com (52.135.67.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.9; Fri, 31 Jan 2020 09:53:41 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::e567:b14d:1dd9:d08f]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::e567:b14d:1dd9:d08f%6]) with mapi id 15.20.2686.028; Fri, 31 Jan 2020
 09:53:41 +0000
Received: from mail-wm1-f43.google.com (209.85.128.43) by AM4PR07CA0020.eurprd07.prod.outlook.com (2603:10a6:205:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.12 via Frontend Transport; Fri, 31 Jan 2020 09:53:40 +0000
Received: by mail-wm1-f43.google.com with SMTP id f129so7943648wmf.2        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 01:53:40 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v18 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Thread-Topic: [PATCH v18 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Thread-Index: AQHVscpTvGiwTCxIOkudkHJ+4ZNq4KfEEDKAgEDExwA=
Date:   Fri, 31 Jan 2020 09:53:40 +0000
Message-ID: <CACqStoe7eoDN4bCBNf7oQBUJC10Rk8QB8S9EVmbkUss7Fntz7A@mail.gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
 <20191213153029.133570-17-tz.stoyanov@gmail.com>
 <20191220234829.55000e54@rorschach.local.home>
In-Reply-To: <20191220234829.55000e54@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR07CA0020.eurprd07.prod.outlook.com
 (2603:10a6:205:1::33) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAWksI+BhSd5N4VbXcU+fP27ed/G0U/SzZyfNkGu1z6ku+P8C7oz
        oRbiMr4ul1oIGCgyMg2Gz9iaZOKPmrtuowrorxc=
x-google-smtp-source: APXvYqy187pSaRJ+VQi+dWmsqBMUKkkruuTay15Y+buzxi637tKC71d5oZDYfUpJwudfd7dV5b+2JESJc+2H3K8MREA=
x-received: by 2002:a1c:f003:: with SMTP id a3mr11367112wmb.41.1580464415951;
 Fri, 31 Jan 2020 01:53:35 -0800 (PST)
x-gmail-original-message-id: <CACqStoe7eoDN4bCBNf7oQBUJC10Rk8QB8S9EVmbkUss7Fntz7A@mail.gmail.com>
x-originating-ip: [209.85.128.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4206e583-ccec-4255-048b-08d7a633732c
x-ms-traffictypediagnostic: SN6PR05MB4000:
x-microsoft-antispam-prvs: <SN6PR05MB40003F73FEF04108A46A794EDC070@SN6PR05MB4000.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(189003)(199004)(5660300002)(66946007)(66476007)(66556008)(66446008)(64756008)(9686003)(52116002)(81166006)(81156014)(6862004)(53546011)(8676002)(186003)(4326008)(26005)(86362001)(8936002)(2906002)(71200400001)(478600001)(316002)(42186006)(54906003)(55446002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4000;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9N9pHOUs0XJYSJxHGjUw45QHRyJvI2A9HTHtxAnuQ9lIHwMeC/+2XS/dsws4/HvK98BoKJrGvK+5hKTxYucQb5UTYwgFLp/kj9RLnE3ZkHu/GxKsJc33hJbXYx4wFApoOdUZF2hSys0/ubOMNlN7QMbfrFbHehA5WXzms6rAY18OGHkhVUmYfEw3hVTPH7shWKxduk6pJSgyRwaCpSSMZkpi0nlj+I/IcKAyeCPvr30+vaBUDHSF64SwM+EuoH5L0NHIDmqd2YdfvsUACn1ClrcgFD6UWqakyDsdKNeICW4PqHEhREdS5pj6T8MB/BHePCCsGuNQVFiJK2mMOvHpS9NYWBtJ3/cryaR5qt89l7/fl6kouZBUXgaPZdd7xEEyTNM5zjX7wisZv+ycPjjbP/ticvnptHXczfZYGnbBgJvEOoXwld3OD/wtJYPEFTvP
x-ms-exchange-antispam-messagedata: +DdfFhJv6a4wvb8nxVNVPcUSaTAxeOrh+Ba4gUGmXa54k4xmLf/Nc/1zHgjFsKmEXcliiIFJolt510PYN1DTU6XRj/qT/ZkTidmLhl2IPkEok0DfFeBFFgP2rNYXunXQ6CU7MxoSKO7H35vMyR6lug==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3DDB78C2551BC4286F2D42FFA716F04@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4206e583-ccec-4255-048b-08d7a633732c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 09:53:40.8758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YhG6oh4RSRPDxh+kQcF9vHD//X9EKjqYL7SY9opFIXpeIEKvWF03zxnInIXx9gfhubcA4L6zDdyMN+xFC2ETLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4000
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gU2F0LCBEZWMgMjEsIDIwMTkgYXQgNjo0OCBBTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQogWyAuLiBdDQo+ID4gKyNkZWZpbmUgUFJPVE9fTUFTS19T
SVpFIChzaXplb2YoY2hhcikpDQo+DQo+IEknbSB0aGlua2luZyB0aGF0IGRlY2xhcmluZyBhIG1h
c2sgdGhlIHNpemUgb2YgMSBpcyBhIGJpdCBvdmVya2lsbC4NCj4NClRoaXMgZGVmaW5lIGlzIGEg
bGVmdG92ZXIgZnJvbSB0aGUgcHJldmlvdXMgaW1wbGVtZW50YXRpb24gb2YgdGhpcw0KYml0bWFz
aywgd2hlcmUNCnRoZSBzaXplIHdhcyA0IGJ5dGVzLiBJdCB3YXMgdmVyeSBlYXN5IHRvIHN3aXRj
aCB0byAxIGJ5dGUgdXNpbmcgdGhlDQpkZWZpbmUsIHRoYXQncw0Kd2h5IEkgd291bGQgcHJlZmVy
IHRvIGtlZXAgaXQgLSBpbiBjYXNlIHdlIGRlY2lkZSB0byBjaGFuZ2UgdGhlIHNpemUgYWdhaW4u
DQpUaGUgY29kZSBiZWxvdyBpcyB3cml0dGVuIHdpdGggdGhlIGFzc3VtcHRpb24gdGhhdCB0aGUg
c2l6ZSBjb3VsZCBiZQ0KbW9yZSB0aGFuIDEgYnl0ZS4NCg0KWyAuLiBdDQo+ID4gKyAqLw0KPiA+
ICt2b2lkIHRyYWNlY21kX3RzeW5jX2ZyZWUoc3RydWN0IHRyYWNlY21kX3RpbWVfc3luYyAqdHN5
bmMpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3QgY2xvY2tfc3luY19jb250ZXh0ICp0c3luY19j
b250ZXh0Ow0KPiA+ICsgICAgIHN0cnVjdCB0c3luY19wcm90byAqcHJvdG87DQo+ID4gKw0KPiA+
ICsgICAgIGlmICghdHN5bmMtPmNvbnRleHQpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm47DQo+
ID4gKyAgICAgdHN5bmNfY29udGV4dCA9IChzdHJ1Y3QgY2xvY2tfc3luY19jb250ZXh0ICopdHN5
bmMtPmNvbnRleHQ7DQo+ID4gKw0KPiA+ICsgICAgIHByb3RvID0gdHN5bmNfcHJvdG9fZmluZCh0
c3luYy0+c3luY19wcm90byk7DQo+ID4gKyAgICAgaWYgKHByb3RvICYmIHByb3RvLT5jbG9ja19z
eW5jX2ZyZWUpDQo+ID4gKyAgICAgICAgICAgICBwcm90by0+Y2xvY2tfc3luY19mcmVlKHRzeW5j
KTsNCj4gPiArDQo+ID4gKyAgICAgY2xvY2tfc3luY2hfZGVsZXRlX2luc3RhbmNlKHRzeW5jX2Nv
bnRleHQtPnZpbnN0KTsNCj4gPiArICAgICB0c3luY19jb250ZXh0LT52aW5zdCA9IE5VTEw7DQo+
ID4gKw0KPiA+ICsgICAgIGZyZWUodHN5bmNfY29udGV4dC0+c3luY190cyk7DQo+ID4gKyAgICAg
ZnJlZSh0c3luY19jb250ZXh0LT5zeW5jX29mZnNldHMpOw0KPiA+ICsgICAgIHRzeW5jX2NvbnRl
eHQtPnN5bmNfdHMgPSBOVUxMOw0KPiA+ICsgICAgIHRzeW5jX2NvbnRleHQtPnN5bmNfb2Zmc2V0
cyA9IE5VTEw7DQo+ID4gKyAgICAgdHN5bmNfY29udGV4dC0+c3luY19jb3VudCA9IDA7DQo+ID4g
KyAgICAgdHN5bmNfY29udGV4dC0+c3luY19zaXplID0gMDsNCj4gPiArICAgICBwdGhyZWFkX211
dGV4X2Rlc3Ryb3koJnRzeW5jLT5sb2NrKTsNCj4gPiArICAgICBwdGhyZWFkX2NvbmRfZGVzdHJv
eSgmdHN5bmMtPmNvbmQpOw0KPiA+ICsgICAgIGZyZWUodHN5bmMtPmNsb2NrX3N0cik7DQo+DQo+
IEkgd291bGQgdGhpbmsgd2Ugd291bGQgd2FudCBhIGZyZWUodHN5bmMpIGhlcmUuIEFzIHRoZSBu
YW1lIG9mIHRoZQ0KPiBmdW5jdGlvbiBzdWdnZXN0cy4NCj4NClRoZXJlIGlzIG5vIEFQSSB0byBh
bGxvY2F0ZSBpdCwgdGhhdCdzIHdoeSB0aGlzIGZ1bmN0aW9uIGRvZXMgbm90IGZyZWUNCnRoZSBt
ZW1vcnkuIFRoZXJlIGlzIG9uZSB1c2UgY2FzZSB3aGVyZSB0aGlzIG1lbW9yeSBpcyBub3QgYWxs
b2NhdGVkLA0KYW5kIGZyZWUodHN5bmMpIHdpbGwgbm90IHdvcmsgZm9yIGl0Lg0KDQpbIC4uIF0N
Cj4gPiArDQo+ID4gK3Vuc2lnbmVkIGludCB0cmFjZWNtZF9ndWVzdF90c3luYyhjaGFyICp0c3lu
Y19wcm90b3MsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBp
bnQgdHN5bmNfcHJvdG9zX3NpemUsIGNoYXIgKmNsb2NrLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdW5zaWduZWQgaW50ICp0c3luY19wb3J0LCBwdGhyZWFkX3QgKnRocl9p
ZCkNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCB0cmFjZWNtZF90aW1lX3N5bmMgKnRzeW5jID0g
TlVMTDsNCj4gPiArICAgICBjcHVfc2V0X3QgKnBpbl9tYXNrID0gTlVMTDsNCj4gPiArICAgICBw
dGhyZWFkX2F0dHJfdCBhdHRyaWI7DQo+ID4gKyAgICAgc2l6ZV90IG1hc2tfc2l6ZSA9IDA7DQo+
ID4gKyAgICAgdW5zaWduZWQgaW50IHByb3RvOw0KPiA+ICsgICAgIGludCByZXQ7DQo+ID4gKyAg
ICAgaW50IGZkOw0KPiA+ICsNCj4gPiArICAgICBmZCA9IC0xOw0KPiA+ICsgICAgIHByb3RvID0g
dHJhY2VjbWRfdHN5bmNfcHJvdG9fc2VsZWN0KHRzeW5jX3Byb3RvcywgdHN5bmNfcHJvdG9zX3Np
emUpOw0KPiA+ICsgICAgIGlmICghcHJvdG8pDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gMDsN
Cj4gPiArI2lmZGVmIFZTT0NLDQo+ID4gKyAgICAgZmQgPSB0cmFjZV9tYWtlX3Zzb2NrKFZNQURE
Ul9QT1JUX0FOWSk7DQo+ID4gKyAgICAgaWYgKGZkIDwgMCkNCj4gPiArICAgICAgICAgICAgIGdv
dG8gZXJyb3I7DQo+ID4gKw0KPiA+ICsgICAgIHJldCA9IHRyYWNlX2dldF92c29ja19wb3J0KGZk
LCB0c3luY19wb3J0KTsNCj4gPiArICAgICBpZiAocmV0IDwgMCkNCj4gPiArICAgICAgICAgICAg
IGdvdG8gZXJyb3I7DQo+ID4gKyNlbHNlDQo+ID4gKyAgICAgcmV0dXJuIDA7DQo+DQo+IElmIHdl
IGhhdmUgbm8gc3luY2hyb25pemF0aW9uIHN1cHBvcnQsIHNob3VsZG4ndCB0aGlzIHJldHVybiBh
biBlcnJvcj8NCg0KVGhpcyBmdW5jdGlvbiByZXR1cm5zIHRoZSBpZCBvZiBuZWdvdGlhdGVkIHRp
bWUgc3luYyBwcm90b2NvbC4gMCBtZWFucyB0aGUNCm5lZ290aWF0aW9uIHdhcyBub3Qgc3VjY2Vz
c2Z1bCwgbm8gcHJvdG9jb2wgaXMgc2VsZWN0ZWQuIFdoZW4gdGhlIGNhbGxlcg0KcmVjZWl2ZXMg
MCwgaXQgbWVhbnMgd2UgaGF2ZSBubyBzeW5jaHJvbml6YXRpb24gd2l0aCB0aGUgcGVlci4NCg0K
Pg0KWyAuLiBdDQo+DQo+IFlvdSBkb24ndCBuZWVkIHRoZSBpZiBzdGF0ZW1lbnQuIGZyZWUoKSBj
YW4gdGFrZSBhIE5VTEwgcG9pbnRlci4NCj4NCj4gQW55d2F5LCBpdCdzIGxvb2tpbmcgZ29vZC4g
SSBsaWtlIGEgbG90IG9mIHdoYXQgeW91IGRpZC4gRXNwZWNpYWxseQ0KPiB3aXRoIHRoZSBoZWxw
ZXJzIHlvdSBjcmVhdGVkLg0KPg0KPiBJIHN0aWxsIG5lZWQgdG8gdGFrZSBhIGRlZXBlciBsb29r
IGF0IHRoaXMgYW5kIHRoZSBmb2xsb3dpbmcgcGF0Y2hlcy4NCj4gSSdtIHRoaW5raW5nIHRoYXQg
dGhpcyBwYXRjaCBjb3VsZCBwb3NzaWJseSBiZSBicm9rZW4gdXAgaW50byB0d28gb3INCj4gdGhy
ZWUgcGF0Y2hlcy4gT25lIHBhdGNoIHRvIGNyZWF0ZSB0aGUgcHJvdG9jb2wsIGFub3RoZXIgb25l
IG9yIHR3bw0KPiB0aGF0IHVzZSB0aGUgcHJvdG9jb2wuDQo+DQo+IEFsdGhvdWdoIHdlIGFyZSB2
ZXJ5IGNsb3NlIHRvIGdldHRpbmcgdGhpcyBpbiwgSSd2ZSBiZWVuIHRoaW5raW5nIG1vcmUNCj4g
dGhhdCB3ZSBzaG91bGQgcmVsZWFzZSAyLjksIHdpdGhvdXQgdGhlIHRpbWUgc3luYy4gV2UgbWF5
IG5lZWQgdG8ganVzdA0KPiB1cCB0aGUgcHJvdG9jb2wgd2hlbiB3ZSBpbXBsZW1lbnQgdGhlIHN5
bmNocm9uaXphdGlvbi4NCj4NCj4gSSdsbCBsb29rIG1vcmUgYXQgdGhpcyBvbiBNb25kYXkuDQo+
DQo+IENoZWVycyENCj4NCj4gLS0gU3RldmUNCj4NClRoYW5rcywgU3RldmVuIQ0KSSdsbCAgc2Vu
ZCB0aGUgbmV4dCAgdmVyc2lvbiwgYWRkcmVzc2luZyB5b3VyIGNvbW1lbnRzLg0KPg0KPg0KPiA+
ICsgICAgICAgICAgICAgZnJlZSh0c3luYyk7DQo+ID4gKyAgICAgfQ0KPiA+ICsgICAgIGlmIChm
ZCA+IDApDQo+ID4gKyAgICAgICAgICAgICBjbG9zZShmZCk7DQo+ID4gKyAgICAgcmV0dXJuIDA7
DQo+ID4gK30NCj4gPiBkaWZmIC0tZ2l0IGEvdHJhY2VjbWQvdHJhY2UtdXNhZ2UuYyBiL3RyYWNl
Y21kL3RyYWNlLXVzYWdlLmMNCj4gPiBpbmRleCAwNWVjMDIxLi45ZmE2MWUxIDEwMDY0NA0KPiA+
IC0tLSBhL3RyYWNlY21kL3RyYWNlLXVzYWdlLmMNCj4gPiArKysgYi90cmFjZWNtZC90cmFjZS11
c2FnZS5jDQo+ID4gQEAgLTYwLDYgKzYwLDEwIEBAIHN0YXRpYyBzdHJ1Y3QgdXNhZ2VfaGVscCB1
c2FnZV9oZWxwW10gPSB7DQo+ID4gICAgICAgICAgICAgICAiICAgICAgICAgIC0tbm8tZmlsdGVy
IGluY2x1ZGUgdHJhY2UtY21kIHRocmVhZHMgaW4gdGhlIHRyYWNlXG4iDQo+ID4gICAgICAgICAg
ICAgICAiICAgICAgICAgIC0tcHJvYy1tYXAgc2F2ZSB0aGUgdHJhY2VkIHByb2Nlc3NlcyBhZGRy
ZXNzIG1hcCBpbnRvIHRoZSB0cmFjZS5kYXQgZmlsZVxuIg0KPiA+ICAgICAgICAgICAgICAgIiAg
ICAgICAgICAtLXVzZXIgZXhlY3V0ZSB0aGUgc3BlY2lmaWVkIFtjb21tYW5kIC4uLl0gYXMgZ2l2
ZW4gdXNlclxuIg0KPiA+ICsgICAgICAgICAgICAgIiAgICAgICAgICAtLXRzeW5jLWludGVydmFs
IHNldCB0aGUgbG9vcCBpbnRlcnZhbCwgaW4gbXMsIGZvciB0aW1lc3RhbXBzIHN5bmNocm9uaXph
dGlvbiB3aXRoIGd1ZXN0czoiDQo+ID4gKyAgICAgICAgICAgICAiICAgICAgICAgICAgICAgSWYg
YSBuZWdhdGl2ZSBudW1iZXIgaXMgc3BlY2lmaWVkLCB0aW1lc3RhbXBzIHN5bmNocm9uaXphdGlv
biBpcyBkaXNhYmxlZCINCj4gPiArICAgICAgICAgICAgICIgICAgICAgICAgICAgICBJZiAwIGlz
IHNwZWNpZmllZCwgbm8gbG9vcCBpcyBwZXJmb3JtZWQgLSB0aW1lc3RhbXBzIG9mZnNldCBpcyBj
YWxjdWxhdGVkIG9ubHkgdHdpY2UsIg0KPiA+ICsgICAgICAgICAgICAgIiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGF0IHRoZSBiZWdpbm5p
ZyBhbmQgYXQgdGhlIGVuZCBvZiB0aGUgdHJhY2VcbiINCj4gPiAgICAgICB9LA0KPiA+ICAgICAg
IHsNCj4gPiAgICAgICAgICAgICAgICJzdGFydCIsDQo+DQoNCg0KLS0gDQpUenZldG9taXIgKENl
Y28pIFN0b3lhbm92DQpWTXdhcmUgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg==
