Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9778C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 12:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiAGM2B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jan 2022 07:28:01 -0500
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:22496
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231317AbiAGM2B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jan 2022 07:28:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cu8358yWWaYjhPPvtTzG0ZXBaCeYPch/Dd0ojEwmvlOhEP5WIJrTeZVCAyWVG0vHNu1+eIfdo70vAfLNb6qREqpb3FfG+pg2stRmKjp4ZOsuyF+a1jibey7fHTSLvLw+Vytfqe2ZopgMPCDJMwJmagxLPbv+vyxrhdbdrWlD7+6C8l1XrF/ye6JuRY1/DZbkInURuOTInuL8hnaRrSM/q90l969tNh0ccvPEL0nusfeP11UL6XIQFjnUtegn9L4EggUE0RZ2ERk0U/INDWftis2Wfe0VRyCscyDSm787vAgZ5XFZ6UWoEn2g9Xw0sHK2WDkPncDeLuPJV9ZqBmOiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5JdNlYmzE1hRD6nbQJneb7q+Lr6HSA3ovMN5tFBzu4=;
 b=SURQEifzMgTQQIQBGTrFKxnhSu+Oqq+8Bgj46qV9gprFUr6mZIIAG39aHZ3rC6125H7Z4EmVOieJWNRhpZ9TdhNYZRzklvoxdPcAaIFpPW4khfaHAJTxHTgfX2Ni4o8U7DWpEzphn0Cd8XkYJtJnQFK+Oi4mezTbmdhzdgwYuAKor6abR8xriNJQhYgXtpYT1D4wivfVKrFYAlrXZHA3ZaFS9PuEEtTyfh2yN/+JpFyyD++2t/a10/8YkS0rkwu3b/2foFwOuO++72yEZVoXOXqes8d0xI1GvOGavBuwbokMhTbZr4677YEX29aMj6qf981NTuAw7d0KxiMLqJJ26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=gmail.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5JdNlYmzE1hRD6nbQJneb7q+Lr6HSA3ovMN5tFBzu4=;
 b=kcK5gIzDKtwxxrAfjprGDwpHg1MY47/rxfzMMPl6tVc8MOPTyePay7+QW+uH+VkS4/NiGLm/YhBBwS2wAELZn3kvuZvNYzc7WkdTLHkyh+FBYZb6cqXkPNv3LuW6mkcPrZWMuPhd7aCrPKRws8KKJ/HEez/q88zVGc+Sxl302UQ1Q+gXabtJx413vq/XEdO6aj0A+oqrfSKKj3hadYBKo8so/d8xFx5kFiSgb91OEO7HvW/dAm8sdibqTZt9yixke30z0EFlT95KwZhHMKBgYQQ5Wy3Kf4z1iQjTlqXy9phPHqcsLvIUQx3GN7Mqr/nhiOsMxq5x05BhrCrKqEJRdQ==
Received: from DU2PR04CA0339.eurprd04.prod.outlook.com (2603:10a6:10:2b4::18)
 by PR3PR10MB4061.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 12:27:58 +0000
Received: from DB5EUR01FT013.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:2b4:cafe::5a) by DU2PR04CA0339.outlook.office365.com
 (2603:10a6:10:2b4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Fri, 7 Jan 2022 12:27:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 DB5EUR01FT013.mail.protection.outlook.com (10.152.4.239) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Fri, 7 Jan 2022 12:27:58 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 7 Jan 2022 13:27:57 +0100
Received: from [167.87.0.113] (167.87.0.113) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 13:27:57 +0100
Message-ID: <1e49fdf9-5720-7703-778c-625a010700e8@siemens.com>
Date:   Fri, 7 Jan 2022 13:27:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Content-Language: en-US
To:     Yordan Karadzhov <y.karadz@gmail.com>,
        Hongzhan Chen <hongzhan.chen@intel.com>,
        <linux-trace-devel@vger.kernel.org>
References: <20220107021846.893-1-hongzhan.chen@intel.com>
 <20220107021846.893-2-hongzhan.chen@intel.com>
 <9e84f570-f9f0-fcdb-e6e8-7b08fcb2932c@gmail.com>
 <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
 <50c5932c-d35b-3739-0277-508c69be9a7d@gmail.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <50c5932c-d35b-3739-0277-508c69be9a7d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [167.87.0.113]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d62d2e-0c26-494c-111e-08d9d1d92385
X-MS-TrafficTypeDiagnostic: PR3PR10MB4061:EE_
X-Microsoft-Antispam-PRVS: <PR3PR10MB40618BBB2DC729E22A1F8F7A954D9@PR3PR10MB4061.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MkAaqhP0bO8wUY5v83+YPTWorJLaU21xxMsc1tOGFfNewWWXfhnR9tc2LLAxPP0jq1ZRSZH0eaJ3X+ph94VYXE6zLufLwBGNc1TQHRMYq/DkN0CaMRT3M27I80hMtWJnvKcEF+ca//96TOc8cls2Uf+vlrnRYjIcWAnput0eO40RDaLVDxRjJ6cZk/mm1MFj+fwul/sSlSR8IQRm/BYrUy/J/cpO2XTDobl3ZCwIvZKczqCsFPAOiFsBr3qxCl4Slu77WxSuHuLg1lRpAADNoaSmjgQgzI0LEn2s677peG8qreoP7rILe9T9CE//mZJ2R/T7af3mZiuC+CS/zn6G1aQpxsIje9ljRcmViZsBeQCZr0qje+mY618lyy6oR2dRwVzC2vHtqJKr8xE9KqtAlIm6UBQe7EG2/U4Z7P/jF/G9rezdG/mJjBV6ggOfhg3KqzE6X6a0lBjlYUXPJa9954FCes1OvjfphAiRgR7muk5k79bTShJ/A+fqGN+50Rl8njz/ajl5prsI2GBBn85N/wMpkWTJfkPlob8lK2KG3Tvoig5JJrZQiG4tZ/0oQSQ7WSm0YvxalIohNEcX7UO4lTj+HIJQw2cgIGPJOhUzRV8usNf7/76b8m4WUXm8vfDpZ4mO2BYZOkXwG/uyTfqmptSC/hRgSXYcwqop/mxansT2HuuYs4gsBnwhxfC0k3o6puRI56RFVOGyU1GuJlJk4j8Xg9Vt84Z1K0wD6NtYQT99stYUmXDxzrUhST/l5NYf+4L3QUr+Z/VfPwcnbKC0ZpQTOmJI8eXJKSNH8fMhXH/M7oSwjCIpZ2TRJkRjWVENmajXOq/VLpkgEgCYWeOKdasfsChuhR+2gdfQu4qso/l8IzQm8oX/4DR7gDqCwrqfVMZ1CsQROuh0fiFBrz8bit7gfF5ARy44Kt+jvTdVtTbF/tIqfiTTmLEQrfXJxkfu
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(8676002)(110136005)(8936002)(36756003)(5660300002)(31686004)(2906002)(6706004)(336012)(356005)(83380400001)(81166007)(86362001)(82960400001)(36860700001)(47076005)(40460700001)(53546011)(31696002)(186003)(956004)(44832011)(26005)(16576012)(2616005)(498600001)(70586007)(70206006)(16526019)(966005)(82310400004)(3940600001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 12:27:58.2948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d62d2e-0c26-494c-111e-08d9d1d92385
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT013.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB4061
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 07.01.22 13:24, Yordan Karadzhov wrote:
> 
> 
> On 7.01.22 г. 13:57 ч., Jan Kiszka wrote:
>> On 07.01.22 12:10, Yordan Karadzhov wrote:
>>> Hi Hongzhan and Jan,
>>>
>>> Have you decided something about the way this plugin will be maintained?
>>>
>>
>> No decision yet. I'm still waiting for an answer on
>> https://lore.kernel.org/linux-trace-devel/9ac9a1af-6829-425a-7943-755decf7c273@gmail.com/
>>
>> regarding maintenance of different tracepoint revisions. That would be
>> implicit when keeping the plugin in lock-step with the tracepoints in
>> the same repo.
> 
> OK.
> 
>>
>> But then the question would be how mature the interface lifecycle
>> management of kernelshark and libs is /wrt external plugins. Those may
>> need to account for potential changes in those APIs over the time, right?
>>
> 
> The APIs are not supposed to change. I cannot give you an absolute
> guarantee, but we will do our best to keep the interface stable. Anyway,
> even if we have to do some minor changes in the future, it will be our
> responsibility to communicate this and help with fixing all external
> plugins we are aware of.
> 
> The whole idea behind the design of this interface is to be friendly for
> external plugins.
> 

OK, that sound motivating to look into the external path. I suppose only
the auto-loading topic should be improved then.

>> We will likely pick the path that is least inconvenient.
>>
>> [...]
>>
>>>> +    eventFieldIntervalPlot(argvCpp,
>>>> +                   plugin_ctx->cs_data, checkFieldCS,
>>>> +                   plugin_ctx->cs_data, checkEntryPid,
>>>> +                   makeLatencyBox<XenomaiSwitchBox>,
>>>> +                   {0, 0, 255}, // Blue
>>>
>>> Perhaps you can use 'cobalt blue' instead of just blue ;-)
>>>
>>
>> Makes sense ;)
>>
>> Seriously: Is there some caption somewhere that explains the meaning of
>> colors? If so, how to hook into that?
> 
> So far we do not have special convention for the meaning of the colors.
> 

But also no textual description of their semantics yet, right? Where
could this be added best to the UI?

Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
