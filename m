Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D6DC282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 15:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3275206ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 15:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=teoenmingcorp.onmicrosoft.com header.i=@teoenmingcorp.onmicrosoft.com header.b="GbSLggPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbgAIPwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 10:52:40 -0500
Received: from mail-eopbgr1320077.outbound.protection.outlook.com ([40.107.132.77]:54167
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732608AbgAIPwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 10:52:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY7kS5gejPOsxzu+aAF3GhZVze7KHj9XipTGRZJus6wi4EkZ98m89OogFxpi7wnUx/CbEMvLSNjajCz5HgZNJJJl05h6m2TdcPkirtBTmslpHRH29EjE2NU1E/nWbGI+ofvYpcafQUcj6WA/SVC2+iLAzrXyfNXyFY7HJnhLdRSc2Sd4waUgNN0leOAO0Nn0Mr+7ArY2ZomaEy8f42gIDQcyYVP3ydJzZFSyuRviW01bc9SLJAS/J7m+HHuFMJFjMYowX1WlYTjwhAiHqxczLLDXuNEfG43GyM2lb//M5cLlo8wDq/ybXEjjy9P5Vc5hTRGERnXG8JBckhp+agFBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkC7wY334/PuMEgerBeWKWnU8lmu8c46b4WPaw0WM5I=;
 b=fKXhyGyWPX6YXVP/jSm84jA8HEsrmr4Biwf5gGbcAeAFoX2RQISfmiP8vzabcKM3tB4TGioCcoLkToSrxVmzgTWPQLpmLd45GkU7JL+XBqtwT/zMAZHhUMZZgCbPnVTt6PD9pci+0jGyFvuGkItVswbrdkAZu4aLKgwee9y0sExwaP2ZeT+HF4XwBl8OgmPsH2yMoxYmOEFh1IKfjjlM+UJNOM5OzrQCaeSdMtM1oWXsKj2pIfGHLY/TqEWRagIH0lhn+Xlx4qcYB+sPJPMwORisBfel6eiEaDmdTbT88NUHrjxijw9TJCCHeWSg5qJMFtV6Xp2aSSltR1rNkxJVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkC7wY334/PuMEgerBeWKWnU8lmu8c46b4WPaw0WM5I=;
 b=GbSLggPNwlvkqCShrUBpqGprO8DFuUG0OVDUhM111gY+GsB6Ass7Jp089ZBBjE5alV+18zJ8l2v4oHZZZHB72RfLeLDWVtbi0lc9zFeI6z0J5osK/e2kez5Fv1Ifi+uTPzf9UxIX5ARTPEZG4fAc4OywLgpi3Lg4vi3nbaskTCw=
Received: from KU1PR01MB2134.apcprd01.prod.exchangelabs.com (10.170.174.138)
 by KU1PR01MB1880.apcprd01.prod.exchangelabs.com (10.170.173.19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9; Thu, 9 Jan
 2020 15:52:33 +0000
Received: from KU1PR01MB2134.apcprd01.prod.exchangelabs.com
 ([fe80::8122:ca17:cba6:19aa]) by KU1PR01MB2134.apcprd01.prod.exchangelabs.com
 ([fe80::8122:ca17:cba6:19aa%5]) with mapi id 15.20.2623.010; Thu, 9 Jan 2020
 15:52:33 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as at 9
 Jan 2020 Thursday
Thread-Topic: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as
 at 9 Jan 2020 Thursday
Thread-Index: AdXHBMTw+SdF2DiUTJqu7dYRkzVe0A==
Date:   Thu, 9 Jan 2020 15:52:32 +0000
Message-ID: <KU1PR01MB21341F5BEAFEB83940758B6387390@KU1PR01MB2134.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ceo@teo-en-ming-corp.com; 
x-originating-ip: [2401:7400:c802:de67:f1ab:6fde:d925:5c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a42f507a-0382-4c32-ad5b-08d7951bf0a9
x-ms-traffictypediagnostic: KU1PR01MB1880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1PR01MB18803C2230E7DE927B8EB74D87390@KU1PR01MB1880.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(376002)(346002)(136003)(396003)(366004)(189003)(199004)(81166006)(8676002)(81156014)(66446008)(66476007)(64756008)(66556008)(508600001)(966005)(6916009)(4000180100002)(107886003)(66946007)(76116006)(52536014)(186003)(9686003)(5660300002)(6506007)(55016002)(86362001)(4326008)(8936002)(71200400001)(316002)(33656002)(7696005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:KU1PR01MB1880;H:KU1PR01MB2134.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: teo-en-ming-corp.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x3/yNC13AOekSE/qUGMtN+qqUFGBy1iCMvcCvuSrrvS1Fx9dIg9JfY1276LQvDkTKHq6bTTIWDn0LKxtshjqzKoefafcXcHpVovVws92typM4iivraV8d/oXqi6074F79x6ogPqeTWABUZQ7dN+YVXfu4hVYUuUiUsh1Eh5fSbPKSFAxw8zv9QPKva0bUYHbKgfQnfVUjU/VkSL1lRBT3zZ3lAqHBg7eRD1IkjhZg1VOUrrQC9zh34MYUOxv0wq8oywzfBckkE+Raem3NZgPUhXueHPO4Urd2kwpyn47LkoMWqSWHfqTj/GBtdMa1bP2HAlLIJI9dTALAPwa+rSQG1dQb+l24iogGU+9V/F5Btcghj+xjsBb4nvnvWNP6LCCpXauuwefwhfqmj/F8fEci5mg2w88a2VPkaBjTUFA8pvVO9ET+YLxhCYzNsYAGIEaU9JcZb3qzuJRztF0OOiaxx04tZhz8kU4d/UoWZav72TRfWLxmfq8NBf7fPZvj0kbqbhLP9qJItpelf+HVxPKxg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a42f507a-0382-4c32-ad5b-08d7951bf0a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 15:52:32.8982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fbfg831SoIg37l4v51pCwPRUxW/NBAATGlmTjE0JlTAHX5/9kJoMsMqN5mLt1IP9TbzIrbWCSWRDPxruh8AEl8jY3R65fhrhScIxs3BZD1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1PR01MB1880
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SUBJECT: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts as at=
 9 Jan 2020 Thursday

In reverse chronological order:

[1] Application for Offshore Refugee/Humanitarian Visa to Australia, 25 Dec=
 2019 (Christmas) to 9 Jan 2020

Photo #1: Page 1 of Form 842 Application for an Offshore Humanitarian visa,=
 Refugee and Humanitarian (Class XB) visa

Photo #2: Front of DHL Express plastic envelope (yellow)

Photo #3: Back of DHL Express plastic envelope (white)

Photo #4: DHL Express Shipment Waybill

Photo #5: DHL Express Shipment Tracking Online Page, showing that my applic=
ation for offshore refugee visa to Australia=20
was picked up at 1619 hours on 25 Dec 2019 in Singapore and delivered to Ca=
nberra - Braddon - Australia
on 30 Dec 2019 at 11:10 AM Braddon, Australian Capital Territory (ACT) Time

Photo #6: DHL Express Electronic Proof of Delivery, showing that my applica=
tion for offshore refugee visa to Australia=20
was received and signed by staff Mohsin Mahmood at the Special Humanitarian=
 Processing Center,=20
3 Lonsdale Street, Braddon, Australian Capital Territory (ACT) 2612, Canber=
ra, Australia.

Photo #7: Page 5 of Form 842 Application for an Offshore Humanitarian visa,=
 Refugee and Humanitarian (Class XB) visa, bearing the=20
official stamp of the Australian Government Department of Home Affairs at N=
ew South Wales (NSW):=20
"COURIER RECEIVED; HOME AFFAIRS; NSW; 27 DEC 2019" and=20
"HOME AFFAIRS; NSW; 27 DEC 2019" at the bottom.

References:

For the above-mentioned seven photos, please refer to my RAID 1 mirroring r=
edundant Blogger and Wordpress blogs at

https://tdtemcerts.blogspot.sg/

https://tdtemcerts.wordpress.com/



[2] Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday

Photo #1: At the building of the National Immigration Agency, Ministry
of the Interior, Taipei, Taiwan, 5th August 2019

Photo #2: Queue ticket no. 515 at the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photo #3: Submission of documents/petition to the National Immigration
Agency, Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photos #4 and #5: Acknowledgement of Receipt (no. 03142) for the
submission of documents/petition from the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019, 10:00 AM

References:

(a) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Blogger blog)

Link: https://tdtemcerts.blogspot.sg/2019/08/petition-to-government-of-taiw=
an-for.html

(b) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Wordpress blog)

Link: https://tdtemcerts.wordpress.com/2019/08/23/petition-to-the-governmen=
t-of-taiwan-for-refugee-status/



[3] Application for Refugee Status at the United Nations High Commissioner =
for Refugees (UNHCR),=20
Bangkok, Thailand, 21st March 2017 Tuesday

References:

(a) [YOUTUBE] Vlog: The Road to Application for Refugee Status at the
United Nations High Commissioner for Refugees (UNHCR), Bangkok

Link: https://www.youtube.com/watch?v=3DutpuAa1eUNI

YouTube video Published on March 22nd, 2017

Views as at 9 Jan 2020: 659

YouTube Channel: Turritopsis Dohrnii Teo En Ming
Subscribers as at 9 Jan 2020: 3.14K
Link: https://www.youtube.com/channel/UC__F2hzlqNEEGx-IXxQi3hA







-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link:=A0https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microw=
ave.html

***************************************************************************=
*****************

Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the
United Nations Refugee Agency Bangkok (21 Mar 2017) and in Taiwan (5
Aug 2019):

[1]=A0https://tdtemcerts.wordpress.com/

[2]=A0https://tdtemcerts.blogspot.sg/

[3]=A0https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----

