Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68FCC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 15:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8753C613B3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 15:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhDMPl3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 11:41:29 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:3175 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhDMPl2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 11:41:28 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 11:41:28 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1618328468;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RS8r+hepWGJ0AWzCrrQfGIXP4pggmogp0/DOnbnhPbU=;
  b=F81ZGdDDJ8pzybu7bdkFGJhISjqOHQ4+8tCJfTDc0XIofTGKKoqpsdhj
   mQKu0tCH1qpTN7X+xPwgVpJYjRCZ67HTl+/guWchYSTHFv29lLiSRI/IN
   6PiEQpoDdFW7NylpV8ZKWtwCDSKL4EAxjE/8ZNuW5/qaJS0jL2+kuew1u
   8=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: 1YddLb718lvk0FEQHtnqqpYus3DsPocZlVLKbWl7mL6jiZslEEs75z++ENXP2A8lJ6rWKEyFGE
 ka1vLlxigFTq2kh82w6URaXeGma8RqU6cLaQJORD72yCD/THpcstgg0mybng8CquFoipeVjHfr
 r78jUZJMrIhXyQisEgb0uzD9sg7TaydILCJjcR7OhSPfIoWWgPVI2T32g7sKLCxgRWSAvGpV94
 ViCjiJmylF5ruGbCqyzZKdVGZw26IHTwHxjco3vryTR2dDsXk3UGOjtouAACriRpW1Cgeuza7N
 lfA=
X-SBRS: 5.2
X-MesageID: 41494926
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-HdrOrdr: A9a23:HZoeN6+egRj/3K368iNuk+EccL1zdoIgy1knxilNYDRvWIixi9
 2ukPMH1RX9lTYWXzUalcqdPbSbKEmwybdc2qNUGbu5RgHptC+TLI9k5Zb/2DGIIUfD38Zn/+
 Nbf6B6YeeaMXFTh8z3+RT9Nt4mzsWO/qzAv5a5815GZ2hRC51IxQF/FwqdDwlSTA5JGZI2GP
 Onl7N6jhCnfmkaadn+O2kdU4H41pT2vb/vfBJuPW9C1CCgljWtgYSVLzG9/jMzFwxC2q0j92
 +tqX2w2oyGv+ugwhHRk0//hq4m/+fJ8ddICMyShsV9EFyF5mmVTb58UL6Pti1dmpDN1H8Wkc
 LBqxplH8N/52K5RBDRnTLR2hLt2Dtr1nn6yVXwuwqAneXFQlsBavZptMZ8SF/0+kAgtNZz3O
 ZgxGSCradaChvGgWDU+8XIfwsCrDv/nVMS1cooy1BPW4oXb7Fc6aYF+llOLZsGFCXmrKg6De
 hVCt3G7vo+SyLWU1np+k1UhPC8VHU6GRmLBmIYvNaO7jRQlHdli2wV2dIYhXVF0J4mUZFL66
 DlP81T5f1zZ/5TSZg4KPYKQMOxBGCIawnLKniuLVPuE7xCNGnKr5Lx/bUp9OCncJEF1/IJ6d
 r8eWIdkVR3V1PlCMWI0pEO2AvKWn+BUTPkzdwb55URgMy8eJPbdQm4DHw+mcqppPsSRufBXe
 yoBZ5QC/j/aW/nGYND2RziS4BfQENuEPE9i5IeYRajs8jLIorluqjwa/DIPofgFj4iRyf4GX
 sMXD/6Ic1a9UC1UnrkgBzcMkmdNXDXzNZVKuz37uITwI8COslnqQ4Ok2m04cmNNHlfqKAsZV
 B/J7nmi6u/omGz8Q/zniZUEysYKnwQzKTrUntMqwNPDlj9dqwbvc6DPUpI2mGcGxN5R8TKMQ
 JWqlht45irJ5iIyS1KMaPkDkuqy18o4FODVdM1h7CK78aNQOJBMr8WHIhKUTjtOzMwswBws2
 tHYBIDXSbkZ0jToJTgqocVCuHZf8R7myGxL6dv2DninE2BuMAiQWYaVTayUciRxR0jXSZQm0
 cZyd5kvJOQ3TmoMmcxm+I+LRlFb3mWGqtPCECfaJxTga2DQnAGcU6awTibgQo0YGzk6gEbgX
 HgNzSdfZjwcy9gk2Ed1qbh61VvcGqBO0p2d3BhqIV4UWDLoGx63+POZq291QKqGy8/6/BYND
 HOej0JJAxyg9ixyR6OgT6HUWw82Y9GBJ2sMJ0zN7XInn+9IoyBkq8LW/dS4ZZ+Ldjr9usGS/
 iWdQOZJC7xYtlZrTC9tzIgIm15uXMkmfTn1Fn+4G+00GU2DPDSLF5lLotrUe20/izhXbKFwZ
 95hdU6sa+sKW33cMeB0rySYDhZKB/fyFTGPt0AuNRRp+Y1u7RyFZWADmeN23FDwRkkLMD70E
 kZW7925bjdOolpO8weEhgpgWYBhZCKNg8stAezH+o1OVcqhHXfN8mS47XJpaE0a3fx1zfYKB
 2a6WlF4/zBXyGfzrYUBKI7PHROZCEHmQhf1fLHc5eVFR6jeO5C9kerK3OxcLdST66eBLUbxy
 wKne2gjquQbCr32AfZoDt9LOZP6g+cML6PPD4=
X-IronPort-AV: E=Sophos;i="5.82,219,1613451600"; 
   d="scan'208";a="41494926"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azngMtQMfqvf41MhFRRM/ov4sbYud2k9POptzkPBcI+p3aowjFpgS7QjSz5/6aKNF5uhrjX1gQ4oWdmR52dDblmvcQvXl0T5gnDi0t5xiOB3bp5SwKLCuIJcc2VxuzIZ5Wd6V5txZmLmdPyyeRqrfP9ObSHGWZh6J+X9G28JPhlpgjnWfAxw1Uck3NglofTK+vqIzKtknC1kaVneosSxU5olPlQXFpV/Ev16VhKWvs9gs3/GzsTyVzQATW5IVlTeEOrvC2CTuH5hDFEWCwSWX9T2W5kE6wvX1fmitnwGi+RbaQyoFMEujjtZeHYLM2cpZhF9+BIAoIIavENjqkYO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS8r+hepWGJ0AWzCrrQfGIXP4pggmogp0/DOnbnhPbU=;
 b=RvY8l/SvKRXDvr4pLzy5rJbbA4VkmZbdusXcQMFJ43lpDRA1iUi9ehhwNkRW09XsbFYKViHZEMkqGavM8jGG3np4Xc+13LYLC0M9B00m7uYfBUaYKHWEvCm1VZ0eFZoki1Et6CZCjlMcoWZ3kZlY3TOnE+atDpFNoHS+gNDuXobVSI/shI0SFNiLDAkqYAqo3SWqH3S/nGvPYHOcQYD2CSbhjv9DHWNigN4b2jq88lStjjxKm3dmlja9mZlNEvYU0d56Hhpj+vJCv/BNIBKC+glcsOrP/p0ey9mVkdEuFo1NdoTRPmwSyE/D1PUhvP50RxUhvAe5fQTSKDse/v89CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS8r+hepWGJ0AWzCrrQfGIXP4pggmogp0/DOnbnhPbU=;
 b=jYZ33dWX3b2AgePi5uxeQe/MWBYfUJPR1D+lo0915qXG3MZC7ioXhLnThcJyQLDv0KXC7fHJUckDeB41cI+Da7VNkNB1MbJEiNjTkVpTFYXV4JnUKlR6NJAHVxxm5NF652vj6K/KD8zX4TxH/rILl0naXSXawBfXuTrKXCdxvik=
To:     Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        <linux-trace-devel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
CC:     Dario Faggioli <dfaggioli@suse.com>,
        Enrico Bini <enrico.bini@unito.it>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: =?UTF-8?Q?Re=3a_A_KernelShark_plugin_for_Xen_traces_analysis_?=
 =?UTF-8?B?4oCL?=
Message-ID: <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
Date:   Tue, 13 Apr 2021 16:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO4P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::7) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a7f838-b224-41f4-22bf-08d8fe918d7b
X-MS-TrafficTypeDiagnostic: BY5PR03MB5048:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5048B352DE8DFE316870321EBA4F9@BY5PR03MB5048.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NUMtz8l1QSN7dVG3yKjdpfF1Y3qJfiX3LjaF7Q18HEXGhBEj7yJ+dKpvsIqH/ZPgKsStFPyduIVowDT+FfnyhfkK47Jd+68aRDlO5BH3F2wid40h/DjlJZP/mFLvDqJNGi07quMsRHmgiqW8lr5EHiLzR97daNDxNJ75jNqlsG5H4g3Cvp7hgdxaPOoXbYQTnuJNIltucp3vQ+JlNWhDFsRNsq52tj5Y3t48Xchjsa7TqtBHg3cXfmgk2T/PkExLL9iTitULHJUlNnGy3imBA9peFb7AZD01iWpy4nK3MmUNKNdrLgZGPUy8IEgGVK6gQPzH7wEV7WLkAFXgG/q3hT5jgU4Y7C5pJ/sv19HPbjuXqmJP9DbLtzhEx+PkzezmD0lye+Rkc3tx7EsDJPOj0uSdmtNhmYg4ISK4P6KobwtRiaU1m7W3DlbZAIpSDjP2moPkDEN57B3HVmzfrRTIRqCOunYNiKwswRn6lrsKtclPWGryD7vSAGunzIH27WXUooqRhO4o/RRKU4X+dRwAIYQ8OzLcnUBeXLemqr/Z3Qa9RPalC3FpZt/gihe9DhzLdVNuOlMU4g5ctwrRojvsp4dODg39X7ANYxCF5Z/PF5mB6zp9SFqQ5ahhCY5lk/e0yKNET6WVfEnHzpSOc43yUxC49ZGrIrSLYiCmjBVvKF3WQ0pnA89q3Vq9/uY2AHmASRGCdtaCG514bx2cffMkNfaFQsXVQUmhkG0yWj7T8lKTBGFXc9awgfqmiQKnoM1uAQBT7M7CVM/HvLYNDar9MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(956004)(66556008)(54906003)(2906002)(966005)(2616005)(83380400001)(66574015)(316002)(186003)(6486002)(38100700002)(16576012)(8936002)(86362001)(5660300002)(4326008)(36756003)(478600001)(6666004)(66946007)(53546011)(16526019)(31686004)(26005)(31696002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QS9VS0NNNDczYVhXekp4UVQxMU1PRFBPR1NHYmRIMnlBc09LN0ZMKytDR0NQ?=
 =?utf-8?B?dWtuaXRBRWwrOThzQWEwYitoM25NdlZQTVdhd1ovblZQSDgvQVlMNnE0d1JE?=
 =?utf-8?B?OWpESWRhakZENDNIVCtKYTczeGRVcmQvdmJiRDNDOEQzSjd5UGNiUlBNTWVj?=
 =?utf-8?B?ZENMRVJacndubmNCb0FkUk52c1NQUzBrTzFvN1FPcVZWY1RsR0Z3bEZzektr?=
 =?utf-8?B?amlvZ21hZmN6MlhLN0hxOXNzVzg3MVRrY1lHM3VDRGthQVJvOTVScFlNbk4r?=
 =?utf-8?B?K2tPeUgxUzBNVllrcThhQjZvTlhrZ3RPSkNnTCs4a3BzaGFNSUJSQ3F4U3dS?=
 =?utf-8?B?NzJYcDBXQ3o0eFJGWEJRRElTY0RwTnp0RTZBYWlBUG96OWFYaE1WNFR4UWdq?=
 =?utf-8?B?d0MwcEx0ZGt2Z011S0diL0IwRTVnMk1IT1pCcUQrZTNpMUxwWnFwNEcySEYv?=
 =?utf-8?B?VEJYR0c0MjgwT2c5U0VEbGxOV21YWHJHYnFRNytwVWNLdndjU0hUR2ZUc0E5?=
 =?utf-8?B?UFFNVG1NK0pZVjlUQitkaUFEbUVLOXNzSVRCM3dDTFpYYy9iWkRhVHIrTTJ6?=
 =?utf-8?B?RHdZQWxCMjd4cTM5dVBqc1lYWGVmc1hlNWd2UGVLLzIxdjh2YWJ2L0RFQk1O?=
 =?utf-8?B?bjd2Wkh0cXZ4QTBmdmo3TklGVGhDdi9UZkZTRVFSdkNRMDJpaVkxL1A0UVh5?=
 =?utf-8?B?dDhmTjNqZy9rN3B0dFg4aDZVTW1ZVmpXMDlidXYxUnlEWGZGSWVuVWVDcFoy?=
 =?utf-8?B?N3puQ3VVTUM0L0NqbG9sVUVKWXFHU2NSRU80VlFKRHNUQnoybUJLUFd4WnVi?=
 =?utf-8?B?VnlnTlMwQjVpZW5xKzMwYksvajUxa1ZRaGVQdkpUc1JyU25PUkZtWURBSUVN?=
 =?utf-8?B?cjBPaWx5SVlLOThYWUVoVUlyM2VabU96dUc0alRESzJPeWFRM3I5RHlvVjMz?=
 =?utf-8?B?QjNibktSODYwbjhFcHJ3SFJicjRQVjNHTUdsVmhzM2lnNWZndVMxcTZNSEtk?=
 =?utf-8?B?aWJoOWs3RHBMS0h2L2U3NU9VbXJnSjZYMW1SWGlnRjVXMkhXaEgvOG8wSlFC?=
 =?utf-8?B?SGp4RXFJK3BHaVpMd081bmFZSjZWRFg2b1JRVzZsZlBkOThZTk9qSEU4REFy?=
 =?utf-8?B?amdVR1o4ZVVOREk2S0gydThsUWZjVk5DL1dtL2FRL00ydWdISTVRN292VHhW?=
 =?utf-8?B?RW8yM3JPR0hsbnduUFpVekNMRGJya1pKNER2ekkzVk1lNzQ5NmlYcWlrRWxS?=
 =?utf-8?B?c3gxU1dWRkgrRVcwVGVUUWJxbENDYU0zNTBlbXlWK0gxWW9hZCtMYytBK0Fw?=
 =?utf-8?B?eW1wVmNydVlJZ0RubGdLQVp2Z0NScmRkNmNkSlpHSEhpMXFkOUtlZTRZb0gr?=
 =?utf-8?B?STVtaTAxU1U1UmVWKzhlNmdRZytQeXpaT056NTZDRk1tejFmT1NIK1p6K2Js?=
 =?utf-8?B?eUJSZm9Pb1JhWjlhWFdzbU1EZVk3R2tkNG9oa2wvSXBZaVhPZ3JubU13Z3kv?=
 =?utf-8?B?ZHVOSnZuZ0hjZHVEQmZCbzNpS1c1OVNjV0VqeFpmUnYvRGVDNWFqNFE3d0l5?=
 =?utf-8?B?eWdsUWk2cDlwMzhRTStGN29PeXIxVG5PaklXMEI3RDJGV1lhWGEyR3VSODNO?=
 =?utf-8?B?MkhZNXBsTjU1blVSQndWbFpjVVZ3UXd0WjlIRWY0UGpBODVYK3hLUmhVeDE1?=
 =?utf-8?B?ZFhCRjVYa1UzVHJHNldxb3dqNGlwZk9zY2wrd0g3K1RvNlR4U0dDRll5Z2ZV?=
 =?utf-8?Q?/rPzXjtDK5x+lWSUConnJhzUWF4Gi8nbe08rKdp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a7f838-b224-41f4-22bf-08d8fe918d7b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 15:33:57.8191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXNC7B+YloLqI/mNijBfB4qFzz+2P1cf/MbmoNDDKog/I8x1HVv+f5EwbG8VioT27crUTiFXsMekHEIhNVHSf5bo4uEbTkn5yyRZxk077oE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5048
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 13/04/2021 15:28, Giuseppe Eletto wrote:
> Hello,
> I want to share with you a new plugin developed by me, under the
> supervision of Dario Faggioli, which allows the new version of KernelShar=
k
> (the v2-beta) to open and view the Xen traces created using the "xentrace=
" tool.
>
> In fact, KernelShark is a well known tool for graphical visualization
> Linux kernel traces, obtained via "ftrace" and "trace-cmd". Anyway thanks
> to its modular architecture, it is now possible to implement plugins whic=
h
> open and display traces with arbitrary format, for example, as in in
> this case, traces of the Xen hypervisor.
>
> For more information on how to build the plugin and/or
> to view the source code I leave the repository below:
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin
>
>
> In short:
>
> $ sudo apt install git build-essential libjson-c-dev
> $ git clone --recurse-submodules
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin.git
> $ cd kernelshark-xentrace-plugin/
> $ make
>
> $ export XEN_CPUHZ=3D3G # Sets the CPU frequency ((G)hz/(M)hz/(K)hz/hz)
> $ kernelshark -p out/ks-xentrace.so trace.xen
>
>
> You will need the development version of KernelShark, available here:
> https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git
>
> A screenshot of the plugin in action is available here:
> https://github.com/giuseppe998e/kernelshark-xentrace-plugin/raw/master/.g=
ithub/img/ks-xentrace.png
>
> I'm happy to receive whatever feedback you may have about it,
> and to answer any question.

Very nice.

A couple of questions.=C2=A0 Which Xen libraries do you currently use map t=
he
frames?

There is a bug which prevents the mapping being usable in a PVH Dom0,
and I was proposing fixing it by switching to the Acquire Resource
interfaces.=C2=A0 A bonus of doing this is that it can be implemented on
exclusively stable hypercall interfaces, meaning that the plugin no
longer needs recompiling when you change the hypervisor.

To others on xen-devel, do we have firm statement on whether the trace
format itself is stable or not?=C2=A0 I think we've be somewhat nondescript
on this point in the past.

For the screenshot, there are a lot of examples where you have a
dom:vcpu pair, and a number rendered in hex.=C2=A0 Throughout the hyperviso=
r,
we're standardising on d$v$ as a format, and e.g. d[IDLE]v$ for some of
the magic domid's (0x7ff0 ... 0x7fff).

~Andrew

