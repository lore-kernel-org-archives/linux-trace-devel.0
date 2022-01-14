Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D40BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 01:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiANBhM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 20:37:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:57398 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233397AbiANBhL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 20:37:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642124231; x=1673660231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PtWhKkKfevJFoddZBX4QzX+RiHO4YlwTOfAKnXULnlU=;
  b=T+H4+DCRbUDqwj12e1iTMvW5Tq/G4ocJz7YEeX2pR7J6DzEnJh21QPAb
   skbansPfoLr8OtKmcq9mOCpDxJApht2qnZUOoxJNRlXc7oPqlFiDqNaEg
   2jYb5+U52Xoj1B6qitWel9qdK+Njz7N3znzl+jXT1aVUAO+h4ZpTfKkLJ
   GR9MOefqdviGPZ/u9nURsQfcL3F8TPUEUE99wWpKafDRXrj5ALHAoiMso
   rlHGdQdFrRMVoPVxgAoBV/db1I6/K61mr8egeu4NVdUKCfBV750qPrDDE
   PBNWumuebjsvPaoP6AveJieQhqUlhFzT1q+gKi65UwzAkLZKUTqDGQ5qA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268521675"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="268521675"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:37:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="529190867"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jan 2022 17:37:11 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 17:37:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 17:37:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 17:37:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3N1hqFgdL7OWVb9DFxCVs01JyvDsjgd8L+G43gYcwsI0h4d3lCtDwUIHx3xrGwDECKs56bGTmUNkmfium+O8x5qMSnXQQtB7zB8R6Ijwy+/vIWsg7FgW/MwEBbjZ5m0rhRhPiZOPliJVJbmQNAyx80wMRCh2OiBrHAH1ETO7l87EQk3UCYH4aburS8QItEqC6e/7ki5GKdcwNgoORTnc3BqLRMWejCADQiHqQCQCrJ3BObYZ21U7x009vxsZqrfsOglqdEhLd3unc7LXbbsh7njLFp5hzEXE8IqkkRh2RSuFtnwmBUg1Vc5gT/V5hsTYaQig56O6ygziTVzPBuUKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Lvg3rewTpL5vMBDx8zWgm19vvbUQWw+IX62s1CoBz8=;
 b=lydDHXgmr2aDo0RN5JHCbRVFYZ4baZWIgDbCQzkxh/06byC2ObzEk3RvrcG7zz/ndvvaNV86UQHqOJfq97dgy1vp99cTt+2JigwVxesv/xXOwXp9UYqrOJHk5BT33ASUndzBW4wWxyhNZ4TQQnqxhqNaOnuNapyp4H7QLMGxG1rUIS3SnbxVGEpCbQCmCb9A6b2TgidelxpJq2rVtabi33xi2tR3REAftrRfB5c1PKztOumKXtxVt9oh/dkKvECIL+km95Z4MQ+OghdFzPgiQVv5ifoUK4GSnWE8Q8zgc2AyCV4HWfrE0FvrdHny69fdjGVg/537tOP6uyMWP9/WAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by BL1PR11MB5544.namprd11.prod.outlook.com (2603:10b6:208:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 01:37:09 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 01:37:09 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org>, Kiszka" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: RE: [Questions][trace-cmd/libtraceevent] how to correctly  parse info
 out from specifial format of event?
Thread-Topic: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Thread-Index: AdgIVSD6mVFfD1+OR1i6bZGO+fUq5wAXANkAAA1PiLA=
Date:   Fri, 14 Jan 2022 01:37:08 +0000
Message-ID: <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
 <20220113140952.34d0f937@gandalf.local.home>
In-Reply-To: <20220113140952.34d0f937@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72a46aaa-a900-42dc-3c08-08d9d6fe613b
x-ms-traffictypediagnostic: BL1PR11MB5544:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL1PR11MB5544703AAC316F8F256D49E1F2549@BL1PR11MB5544.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qNX/lpOf5wZIDDKgKsNZxCFA45gIXcoVhtahTqMPs8iB1XSUVhCKqoW8sySLwv+RSQcMkwaKklZ2cRR71o43A3ten20zVXjyzlQH2+ViCyeuEErApCPzAQ5JsgKM6oI1nEocupuBl71k/cue4uwe15AbM4ow1nCaMJ94rChKM7CzUc5NPn9fRp7TT9WgMLuqEsVcVwBL2d1sOOqE/u5vYT6P7T/AApxj8Y/A2TAcmUbAmPLRDLtkVtdqf570HBhOnOABHKWEmcJyeY5bgiQgbs3C//A1LqJd4cr+JQFVUxwbNHg+3aAxD1ahEqJeKrMQzDoSr7gYTeD5+3CDAhwAfscdS60EMjT/8l/IuLlmniW+LseGc2hBUoTHj85nCxbByaaQv+5kakj4fy8vbincv+hEvLLL4WOxuKQJYrvuecRdi6r1EJpPjAKmhYS4B9XiZd1qcivoplBprLQtwi5nz57vIj+kyt9tr/wKvvgo4MNj5drQPPUOp1IAGARVfq/CvnkuVACRDVa3mqyXgiOhF+w8upcot/Wnv7HBF8eMr3HlGBpOQh575Rf0knUcKaWq1QNhfrZK7zYW6Wgr6QSTu2qyk4LfL25PLOH2JEsS0SHrKgTPuSmb1LJPesReTQckHGH2nXdVLY4sA5sKdlTqNwguuyRzYRfUjT8NUOxYNaLnhU+X98f/T6/4P+AiV3uLs9jt3DR4PiYEnKvE6a6aG3suYVkgc1K1rTJwgRDUtVu6RTIxKrS/LJqA23sNcZa/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(71200400001)(7696005)(76116006)(33656002)(8936002)(6506007)(9686003)(508600001)(26005)(86362001)(4326008)(66946007)(66446008)(64756008)(66476007)(66556008)(8676002)(52536014)(82960400001)(54906003)(38070700005)(55016003)(186003)(316002)(2906002)(5660300002)(38100700002)(122000001)(83380400001)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5QKf7bZA5I4evXLf4yyWEG68FEOV3ufCZYRhTlv6uiKBFP+0x/etnjv4g9TG?=
 =?us-ascii?Q?AU5hCjEfxWOsIusENGIp/o2bdTfWpdaSYXO/Emf2vHmuzNxWzmlMxbS6M1H7?=
 =?us-ascii?Q?GuOLcLBsB98l5P5ARy93pdvwwBkl0re0tYGRid8afxLsJ0+gVeNDhe4JRQEz?=
 =?us-ascii?Q?myNgmGlWenxarhqamWVUQ0QAY29aSAe3zMVLuJkUqulHIBgp8+f88HEkMYCm?=
 =?us-ascii?Q?UUnyCUlfkvPjY3wD7T/FmMzc4zL1BXdZ2ubMyOqxKGj+5KENwlcl0k1c7Oxr?=
 =?us-ascii?Q?7klZcD+8JqEdwRm+W8lkGLmn9SVyxw9IIICj5FuABW5zE9VxrBafzM1IMZBA?=
 =?us-ascii?Q?hyJLwy0HzX8fVv7tBN7BZ8YJX4B1szZT0T2Y5qtujQhGz+r0jPiX0u4H3GH4?=
 =?us-ascii?Q?yN/367a7nAeJoy6r/NcnkdW3GDtBxhsB5nLM3IpzyoaD6/XKjVPRr72GMF0v?=
 =?us-ascii?Q?NJs2zpqgHXMwJFlaE1Ln/2R2uqkwK+sYfWx4BEt5DV4pHxFou9WFUIEmGQyB?=
 =?us-ascii?Q?OhPeOn8rmD4Sn0FpLrBq1mKzAcsoNFCEFby4nlwWCufcbr2mtyaroClO/12s?=
 =?us-ascii?Q?KpFuUhr9IrZ8LDo4hfin2hvtbr9mXvgVZDxZyU5uj/a4H/YRAvtcpGFLcLlv?=
 =?us-ascii?Q?iHMgMh1qAjLEnQvhZmZZB/Hyevpd7GlPeZkIsRs2BLTmcoju16mnyaYxUAFJ?=
 =?us-ascii?Q?WKeoYgK6KgllgjeIBlj4Q89vI/Ot6F32rUHPRSho5ChAI82mvGrANuoxaPtl?=
 =?us-ascii?Q?HyNTRf7GYYRd+3zP3RMqkguuniHJpQtJBy4eNX3MEKmhFUkpkFk0ywgLmFoJ?=
 =?us-ascii?Q?SspqR4Lqs7hp/enZTyoCf5FE7O3q9JzSROKSy8r9e/UnZGico1aVTibnoTN5?=
 =?us-ascii?Q?/St4/2esnLpqtA2cI1wcyaHPwmTKhF2rXfQ974nue1vnl9cznQAmKS2TnOE+?=
 =?us-ascii?Q?WnkXxQnxrIBWLVotfcGZn5SWw+gkNRC7IT0cFXvsV7mJCRAwBIG2Tb/A7wP/?=
 =?us-ascii?Q?+P8ljQaDj1H4SD4fgDRPX+pm/MUTM1vNdEVLIaIrFeutMTF+9wky/5jOHo27?=
 =?us-ascii?Q?3cxx2fiImvtUiAlkMx6kZohQhgu4tytXxo9kordjPOpVPm4zbn6t5llEsSSe?=
 =?us-ascii?Q?yM8ErgGYVbI05RGDisH0OEWmwRjbKRCHp+5+UyiLWHEwRXs71LF/1vSBOu4A?=
 =?us-ascii?Q?Gq2dQPgfXk84QlP0OjoxmwfEDnAn3gCfi37YqaZ8ahRNomjsEg4V2ZtCjTI9?=
 =?us-ascii?Q?SlKYCAy2AiYaO3lNtSs3/A/R8V9yVwJ2Oi2uy+II8fGbJJ0gnc5JQ0ADNuDY?=
 =?us-ascii?Q?A1YmllxBpc5VnB4RlYOO48crSJcRDlKIfphHenzRmxR6hV4RxUPBEK0Hf752?=
 =?us-ascii?Q?hUzfGN2X1jWykaxDUlmKTIGFf2W/83lFCkej/Y8WWUbOusyWemX4vnL9EHBy?=
 =?us-ascii?Q?hwu+Qf3nYH0tLqqbHEU2Cp0GHoz7q7WAOxgqpupJiC6FZoRQ/xB5QCXZKhe+?=
 =?us-ascii?Q?TWVXsCLLlfXI2/EErkIeGRmHDuyJLePZnUC+CLvbkEBy1EXzsa3SheSJyybt?=
 =?us-ascii?Q?0vyyG0dI0FqCFB46CYQJknGnkfb4kbq/4LcPIqDRHehnKgEU+zzgDZKoVB01?=
 =?us-ascii?Q?Un2OugzoQusUR+RbOiATeDs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a46aaa-a900-42dc-3c08-08d9d6fe613b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 01:37:09.0163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3u046o4MbeUZXGgmJx/d15EJDzbhMvVVwofL8B+HMOqCSxSz0XM8ReSiqXikEAA0Y9DSp1LyK2+OBqVSV6br0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5544
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


>
>-----Original Message-----
>From: Steven Rostedt <rostedt@goodmis.org>=20
>Sent: Friday, January 14, 2022 3:10 AM
>To: Chen, Hongzhan <hongzhan.chen@intel.com>
>Cc: linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>=
, Kiszka; Jan <jan.kiszka@siemens.com>
>Subject: Re: [Questions][trace-cmd/libtraceevent] how to correctly parse i=
nfo out from specifial format of event?
>
>On Thu, 13 Jan 2022 08:20:16 +0000
>"Chen, Hongzhan" <hongzhan.chen@intel.com> wrote:
>
>> When I tried to analysis trace log that captured from xenomai system wit=
h kernelshark, I found
>> that it report "FAILED TO PARSE" for some events. These events have form=
at like [1].
>> In trace, these events would be printed like [2].=20
>> At first, I was trying to develop new libtraceevent plugin to parse this=
 event correctly.=20
>> When I refer to code plugins/plugin_mac80211.c of libtraceevent to parse=
 field param_ex=20
>> out for this __data_loc type of data, I always get value 0x380018 and It=
 is supposed to trace_seq_printf=20
>> 0x38 size of string got from offset 0x18 of tep_record->data but it fail=
. After debug,  I found
>> that the data start from offset 0x18 is not what we expect and first few=
 bytes of data is like [3].
>>=20
>
>Could show me a full binary dump of the data for the record in your plugin=
?
>
>That is, something like this:
>
>tep_register_event_handler(tep, -1, "cobalt_posix",
>                                   "cobalt_pthread_create",
>                                   dump_event, NULL);
>
>
>static int dump_event(struct trace_seq *s,
>				struct tep_record *record,
>				struct tep_event *event, void *context)
>{
>	unsigned char c;
>	int i;
>
>	for (i =3D 0; i < record->size; i++) {
>		c =3D *(unsigned char *)(record->data + i);
>		trace_seq_printf(s, "%02x", c);
>		if (i < record->size - 1) {
>			if ((i & 0x7) =3D=3D 7)
>				trace_seq_puts(s, "  ");
>			else
>				trace_seq_putc(s, ' ');
>		}
>	}
>	return 0;
>}
>

Following is two dumps, please check:

          smokey-447   [000]   320.193156: cobalt_pthread_create: 74 02 00 =
00 bf 01 00 00  40 37 4b aa ab 7f 00 00  00 00 00 00 18 00 38 00  00 00 00 =
00 fe 7f 00 00  60 c3 24 90 ff ff ff ff  5c 81 21 90 ff ff ff ff  d8 bd 8c =
80 90 c1 ff ff  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 =
00 00 00 00 00
          smokey-449   [000]   320.196623: cobalt_pthread_create: 74 02 00 =
00 c1 01 00 00  00 e7 6e a9 ab 7f 00 00  01 00 00 00 18 00 38 00  01 00 00 =
00 30 00 00 00  20 7c 82 77 fe 7f 00 00  60 7b 82 77 fe 7f 00 00  00 2b 89 =
18 55 a6 fa ba  40 37 4b aa ab 7f 00 00  3e 3d e2 00 7f 55 00 00  d0 7b 82 =
77 fe 7f 00 00

Regards

Hongzhan Chen

>
>Thanks,
>
>-- Steve
