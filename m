Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1C0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 13:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0084F60FD8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 13:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJHNx6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 09:53:58 -0400
Received: from mx08-001d1705.pphosted.com ([185.183.30.70]:33884 "EHLO
        mx08-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhJHNx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 09:53:57 -0400
X-Greylist: delayed 2382 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2021 09:53:56 EDT
Received: from pps.filterd (m0209323.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197JORFn023310;
        Fri, 8 Oct 2021 13:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=S1;
 bh=kx6DfamcvK4x5EzzwyGpb5bj+bXgU3ak9aYxdeR9Tu8=;
 b=G4zAbGga+bjA6+Aui8PuSMoFKNqUdU2gbHddbNaTnOp5Marh0LDolb14ug5vg/0vmCF5
 x5pM2R/GHDBCFOlDX8fj9cqPVPXQfRfet/0IP/h4f0v8Ao5XQQTepVL7HPkh2xq7trJ7
 eJIVTjIh7EYGDxi7sLsHMzS7B7lzLR7ZpHwM0maHnOFL06s+DD+W3vRPhN/z0228LJYY
 pxVpFoWkIgu8OpdMt9TP6IwoNYc9cp3SyzCD1szQn47evPADT3I1n7kwzbofGpayjAKE
 16e+FIwwRtCL8U/h/XCscXQ4fqeX4blw/ZzsvlATN1OI9ZwbFDOZENkukNhD5oOyP4iN JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx08-001d1705.pphosted.com with ESMTP id 3bhrm0jk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 13:12:01 +0000
Received: from m0209323.ppops.net (m0209323.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198DC1m6015659;
        Fri, 8 Oct 2021 13:12:01 GMT
Received: from eur01-ve1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55])
        by mx08-001d1705.pphosted.com with ESMTP id 3bhrm0jk0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 13:12:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQ9paMdz2EzjIL4JY8kyzsZZz133CB87KAtke/Hg+esyJPfDG51NkcBnh4vicYyx/EBme/mZpnqU80Mozyqq2O3MCGyYx1aoGhC623V61Zdl8l59efwqIt4Upo85AeFNRktbZMFhFW0+rq/T1/VCDLWqIJNVsStyMNurB9h0uLrxXFwAepcT2VECsjEk9VG1VLIu40maNbfFJADzRBiMpKSL6vtAm8/aSiZ/fBqB/ZXKhJvZrseDfGpS3E36dOUmUn2iijy8PvB8+GQarlBEKv4s6by5WDpwX0Ol3RM0Rj2fXPc5ldsZIBOSYVhJri1ONywAKi+JsCiVSldy0V5WPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kx6DfamcvK4x5EzzwyGpb5bj+bXgU3ak9aYxdeR9Tu8=;
 b=J3/X8No0i7N+RE2PmWaXpc+1OwLoVcPznoBs4xvyspMW+3lWnuLKeJinCreE5SuXR3LfCxoX7+dLW9W5amlLTnD1PScmgGU+rsvCZ91/+x1OdQaelIvMyJBBX1KWwm5o648JWSFJStjJ+GroeQB9xzYLR6b/wy9c+0gHEpKq3ms0/8Zw4ZY1jcxURB3tmgGctc4PJdeIuQH5dpmvjJKHRNbqTlLm+rvWbxRafQ8iwndDuKDG0AQ58ipnEc39GKkO8h3DsM0t0b6cqb6PHWu4L94E4SlcCb6/6apRzMRzOgUljz2D2ddFY+zlnmVb6EfLKXO1XCV8SmN0V5l5712a/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kx6DfamcvK4x5EzzwyGpb5bj+bXgU3ak9aYxdeR9Tu8=;
 b=Rf6RDDenqzHXG8Y5B2B1x+TYWB9S8A/9QPzv+p5iwxvzN+YA7M1VIn9jsw5iBO+s+zU2WOJnWO5Phgly5SaNm+DADOtWzuLH7E3lF/K5oX4O4hJw5fupFmZWg+V0Tnu05aIuzM22pAUxllrcaHERl6Esx8LlPoFUsBJf4iao2gw=
Received: from AS8P193MB1687.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:3fb::21)
 by AS8P193MB1318.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:33c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Fri, 8 Oct
 2021 13:11:59 +0000
Received: from AS8P193MB1687.EURP193.PROD.OUTLOOK.COM
 ([fe80::bd40:de33:7bfb:4771]) by AS8P193MB1687.EURP193.PROD.OUTLOOK.COM
 ([fe80::bd40:de33:7bfb:4771%8]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 13:11:59 +0000
From:   <Peter.Enderborg@sony.com>
To:     <beaub@linux.microsoft.com>, <rostedt@goodmis.org>,
        <mhiramat@kernel.org>
CC:     <linux-trace-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] user_events: Enable user processes to create and write to
 trace events
Thread-Topic: [PATCH] user_events: Enable user processes to create and write
 to trace events
Thread-Index: AQHXvEYTxX3HChgP5Uq+OCm0se4KWA==
Date:   Fri, 8 Oct 2021 13:11:59 +0000
Message-ID: <2a271ca6-1a01-25f5-1b32-9eb79e2d67ab@sony.com>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
In-Reply-To: <20211005224428.2551-1-beaub@linux.microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc177a53-05ef-4386-7734-08d98a5d3625
x-ms-traffictypediagnostic: AS8P193MB1318:
x-microsoft-antispam-prvs: <AS8P193MB13184E81CA5F2703DC19723686B29@AS8P193MB1318.EURP193.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W8adKCszvtxI1GUMKkAdJ5cfti9yxwYjZghVnxmud1jm6at1tEYgzkdcVsTLOdh3OMQS3NLnLsTlPYQviK8E/0ZH+zGYIAtUEC/Wis+8jx3hfO7xM9fZdopCCa2j3E174yy9NRJkOWSSnIOXNe3uFzgwttWZJ6Gr1yq7HC+FPKm59XZrKu3lH9hXYZmG0ts0HuM8/OawePVR4at+XqkJGRou/0oMI5Haoio+4Nded39TNXkiUZa7N7LGcPC1ZYq4zauyYcQpLXaoYD1xuwI73HlEg79jZI7/TjMxT+UQGLHv9r/4m6NuGYcRoSlJCei7ukSCatygp6x9QxIlVTrsxnmtyPHY5GhCPWJhuqsf4HLrU4k7Cg6sGFfZr5+l6ERnRrcI8Z3T0Uz8z36/6w6gq2xMevhgWia+nDGA7JSSGoW1cLg5ChvZeOXKLprNPkC38nHhFy8iKWsEyXW/QyeJ9XCeo6Ho9dFvk70xds732fJBObxkfOsmmYOpsrPui+ikon45vrsKHNi0OjJoyfzM0UJzWobfGr+/3Eycc3KHyv1CmfyHSetih5FCra6gMahJnx2F0Yo4z2TG9KWIKQaVjbL9g19cn84WiFxd2MQGo87x8FUq/qsJFbv2E1eMqFbhWrSkewV65xjcQzrMIG7jzRgqLt+ZPRObsK3t3o0EVe8li0CHY06+f4O0NxcarFGWWZynIiR6N9MbgBwDONVvI9hGliZlWezuhVQivjcWXYd34phQ+ATrcvipWi1/YOmteiZoKn01C+v/g62hipLAHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P193MB1687.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(316002)(66446008)(64756008)(66556008)(66476007)(2616005)(66946007)(83380400001)(54906003)(110136005)(31686004)(76116006)(91956017)(38100700002)(5660300002)(53546011)(2906002)(186003)(6486002)(38070700005)(8936002)(8676002)(71200400001)(36756003)(6506007)(6512007)(86362001)(31696002)(4744005)(26005)(508600001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHFic2lubkJVQW5FWUgxKzFDR2M3YktBencyTUFQQjFzZmJZSWE0RmloNmht?=
 =?utf-8?B?bXRwV2ZaY2lUL3lkQzlvZEdEQmIvMnRBRE42Nk15aGxiblc1TktvbGhhblll?=
 =?utf-8?B?bEovaGRYQjg2a0JYUmdkbmR2a0h6RjZjZEFyeUlZZ29zbTdDWFBSQUwxVlEr?=
 =?utf-8?B?YTJsUkxueDkvWXdLQjAzaWJnUFRtZFdwVmF0Q2ZGdGNmaTB1bitURkZUSDR1?=
 =?utf-8?B?QTdncVNkRUFhK0dLeFVNNldTSmxRa0NPWjRWVm5BUkZ0YWRERmtBSndwS2lQ?=
 =?utf-8?B?WG5qUHJaTlN2SDFhNi8vU3h1ZG9KNkVkZUp2TWNZbjFtWlJlc0dIZktRdU1K?=
 =?utf-8?B?dC9xNUc5amMwLys2MTdIQTJYUkJ0OWY4Q3pCSVp3NkV0ZnQ3UFJHMGdYK3ZY?=
 =?utf-8?B?NUErbGhvZDVBZTN1NzdxblNDcG9SQTVrdFBlQWUzT3JwRmJoVEl3UWFWMkNj?=
 =?utf-8?B?S09ianNORTc4VGJqNkJnTjZwMzBRNVVkVVhCU3ZuYm0yaWswQnBNdEt1bmNy?=
 =?utf-8?B?U0p0WWtHbU9qenBETGV5N1pSTythajR4aVFqVHM1d21pSmZCbGJJbTlUMjVy?=
 =?utf-8?B?RTRFUnNTb1REME90MWdnOVN4NXJvWld4UThwYmI4OUhjTHV6bXFJcE96RzBK?=
 =?utf-8?B?aEorR3RQcUFmTUxOMTU3VWszRVNaREtWWkNzdkdRcUtXaVBPUVo5a08zeGNl?=
 =?utf-8?B?U3ZadE4xOXN3c0J2cHFEcnJQZ1liRFY3WjY0RGRZSG1zOW1uL0dUN3lRa29S?=
 =?utf-8?B?NmVhRExHYUhZOFRTU2hDTWpYbFhPR2xPeE9DNnd6Vy9uM2d2b1gya09OL1JN?=
 =?utf-8?B?S3U1MkhYNU5RMFJTWnNEbnBwQjhjVHAxek8zQWxxTnFQUlh6aGpVdlRZcVlh?=
 =?utf-8?B?a2NtTFhQYXMrZ1BRZEhXZnJSdVRRZzBrRjU5RmZCeDNiTmsxak5wank0QVhG?=
 =?utf-8?B?R1Y4RDhGMFlpL1lOc1F4MGxxL2xjclFiQWZJQUtHQ25Iem0xcUJFU1VqMjh6?=
 =?utf-8?B?ajQvckpEaFBsdzhaeExuTDZKTjZDUUF6RGdiZDluWmE3bTVnZDExbDI0RkMz?=
 =?utf-8?B?Q3d3alYvZjV5UzB0VEpRcE1SSHFtSzNNd1JkT0ViZ1hpak53N1B3VzZ5NThh?=
 =?utf-8?B?aVhqeTVBcUl6UGs5Vlk2QjhNZnJoa0FCL2xXd3kzbXV2WGJ0WGdIdHQyQndM?=
 =?utf-8?B?aThFRWxoRllnYWJKYnM4ZFdSbUJidlB4cHcxNGhWWDBaTExaV0FUdWlwd2hH?=
 =?utf-8?B?RHk4MGlnZFdWRld5VGtHRHV5Q2o3VlBvaHlITW0wLzhwWmdiL3p5K1dzRytw?=
 =?utf-8?B?N2ErVWlqU2tNZDBzazI0STVIWUJzUFZZSWFtcUdRMEhYRUhkRXVpQUM5aThn?=
 =?utf-8?B?K3E2MFhWcCt0TWpkekJNU1VNV21vbmVkRE1IUHc3SlVla2Y1Y0pwbDgzMCtk?=
 =?utf-8?B?K1UrSWNnS202aHFPbTNsenl5YjZPa2dVMVIzM3hjZ2NtalJGSmZXQ3hBYmdF?=
 =?utf-8?B?SSt3ZUxreG1LVUtjc1RXc3ZiSDNxY1hHQW1qL1k1c1h0NmJWYmFJRHNhc0N4?=
 =?utf-8?B?SWR4THJUczdCb0JwclJaSkR0UUdMQVpjdzQ2U1YrMlZ6a2lUYW5vbWkwWXFO?=
 =?utf-8?B?OWhhbjQ0OW05eDEyUU1mTExPQjduZEJYdDBJYjNRdGJlcFZXRW5vMTNocWZi?=
 =?utf-8?B?OHFwUVV0NGFhRU9YRDdpcHJuVWFxSm4yZVIrd2krMm9PbUhhQk41N1ZQWFNI?=
 =?utf-8?Q?OFYVuTSoKVnwGFPRiDjOrJNpyZqPCqEH0pQHe7Q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D16847DEE9511149B449B4E48D5B5539@EURP193.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P193MB1687.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cc177a53-05ef-4386-7734-08d98a5d3625
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 13:11:59.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kUXdTz8zkdEQ6SDCClyEzXy/eX+5wbLEe8drDOjO6b5+JwqkIlXEZmICVPrvMwjJq4EgvompUITInm4jRVTssALF+tPgvsYKdFsyOhWAs9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P193MB1318
X-Proofpoint-GUID: t732TsRe0DMrYHSHwlKBFtGOL-xDNQd_
X-Proofpoint-ORIG-GUID: vMPVRunrOSyeBihbsoKA1GQZjEV7RTbE
X-Sony-Outbound-GUID: t732TsRe0DMrYHSHwlKBFtGOL-xDNQd_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_03,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080080
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gMTAvNi8yMSAxMjo0NCBBTSwgQmVhdSBCZWxncmF2ZSB3cm90ZToNCj4gVXNlciBtb2RlIHBy
b2Nlc3NlcyB0aGF0IHdpc2ggdG8gdXNlIHRyYWNlIGV2ZW50cyB0byBnZXQgZGF0YSBpbnRvDQo+
IGZ0cmFjZSwgcGVyZiwgZUJQRiwgZXRjIGFyZSBsaW1pdGVkIHRvIHVwcm9iZXMgdG9kYXkuIFRo
ZSB1c2VyIGV2ZW50cw0KPiBmZWF0dXJlcyBlbmFibGVzIGFuIEFCSSBmb3IgdXNlciBtb2RlIHBy
b2Nlc3NlcyB0byBjcmVhdGUgYW5kIHdyaXRlIHRvDQo+IHRyYWNlIGV2ZW50cyB0aGF0IGFyZSBp
c29sYXRlZCBmcm9tIGtlcm5lbCBsZXZlbCB0cmFjZSBldmVudHMuIFRoaXMNCj4gZW5hYmxlcyBh
IGZhc3RlciBwYXRoIGZvciB0cmFjaW5nIGZyb20gdXNlciBtb2RlIGRhdGEgYXMgd2VsbCBhcyBv
cGVucw0KPiBtYW5hZ2VkIGNvZGUgdG8gcGFydGljaXBhdGUgaW4gdHJhY2UgZXZlbnRzLCB3aGVy
ZSBzdHViIGxvY2F0aW9ucyBhcmUNCj4gZHluYW1pYy4NCg0KSXMgdGhpcyBub3QgdmVyeSBtdWNo
IHdoYXQgdGhlIHRyYWNlX21hcmtlciBkbz8NCg0K
