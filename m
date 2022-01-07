Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A21C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 11:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiAGL5Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jan 2022 06:57:24 -0500
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:4992
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229624AbiAGL5Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jan 2022 06:57:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6OzSeILFJJuSNou42Otia+ITk+JhIwWKFG+wcV387EkcZQZhatSDywBWGaCOU9tF37v1zA5OSADXhGLIPNsLCbfsV5bSSPNsWA9AcTdW4F2Kq4uWnjQ2pXtfC2VAYOfyuYeNJrSXo4E4eE1D5urCisuavRriLiCwM6jaKrGbZtGyoQaNMGAFjVBwhqWiQpXfw4+YwfBComqa9c/gQJJvT6Qg384LrEaQX3TruFzLLyOn2gG6EsySiomZvM4Ok3tYvrBfpvEd/BM6la3EFQaF9k+9XtjBKoqREIoKBWg6BzPQuJuDc48gHNIlOCFXiDiNrWXSbw+Oz6f1s+ll6ZpTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXOfVmZ6cL3SBTUf6lx3WlPO5b70uDDLT8E5lRLlXqs=;
 b=PUYXl0pIzLq3oHgdlNAQRufL7Udz56KEZD1dCVv1PUPqfre6gRfekfFydVIUi5lfUtKtKwRkb1wUw1UK+B4aWtbaA7GJZYkySlXcUntENdU3uRHUB7J29bq4BFWiGvFkj41uxZt5P/t4UPsyfpRCjb2ZGPuDlo7b0JBXsRCjSGIlcB2ZQPrJbJF+9F29udBBm250oC1Gl8LNzI03PZMqnK9LWHmCR+VjIrldkBeVdGmERRUwV6aF/AmUhqcr7nyPM3qGwvAa5HlJLGgFbxWWOdNC33rETs0Ui4tLQiMKuJtmoUJ9HEYE0MqU3dr/ykO5zF9DB1c2pGhMtUnXvLEv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=gmail.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXOfVmZ6cL3SBTUf6lx3WlPO5b70uDDLT8E5lRLlXqs=;
 b=qiest3nUDM1OgZz9aaBBqFfWC+Sndl8ytqZ9EaLkb1bX+KoLZl5z+A9oJcnl9mFkhsguqVk26sVRIsope4So9ahRcBz2a+owh/KtEjea1Y65Ji034hIH6wLQzdpVsjXCSPiwf9gVP3790laErsRdA3OIUhggj8uPhnS5/6ATxQCqDIbByHhysNWMRBdTgOTcFz79BsPexJRh5N7DSwYYsWE/4hkArVNVRdTnRktYJT3Bku+GsUubADYA+P35f5Hhq6BSweYjxfG/D4b+pBlxgbPr7G99p5aE4cYaGB+LCkcnCLKhT8Vf6iGwMy7emjBDt+G1g+prhEwdsfbNk2AOXg==
Received: from DB7PR02CA0027.eurprd02.prod.outlook.com (2603:10a6:10:52::40)
 by VI1PR1001MB1214.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:64::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 11:57:22 +0000
Received: from DB5EUR01FT052.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:52:cafe::99) by DB7PR02CA0027.outlook.office365.com
 (2603:10a6:10:52::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Fri, 7 Jan 2022 11:57:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 DB5EUR01FT052.mail.protection.outlook.com (10.152.5.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.9 via Frontend Transport; Fri, 7 Jan 2022 11:57:22 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 7 Jan 2022 12:57:21 +0100
Received: from [167.87.0.113] (167.87.0.113) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 7 Jan
 2022 12:57:21 +0100
Message-ID: <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
Date:   Fri, 7 Jan 2022 12:57:21 +0100
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
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <9e84f570-f9f0-fcdb-e6e8-7b08fcb2932c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [167.87.0.113]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75381888-08bb-4dec-10fc-08d9d1d4dd2a
X-MS-TrafficTypeDiagnostic: VI1PR1001MB1214:EE_
X-Microsoft-Antispam-PRVS: <VI1PR1001MB1214463DD2882F7146877E69954D9@VI1PR1001MB1214.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtphVrYVB9DH5E3bskxZziGuwM1G8BeXZ3nzSGEjE4YPQmKFdyae2MaAyGRnu8GJB/ROcKYtpaP4M7Rdismy6/kXkcHROz6HnVdiHVtADmR7MyDabK5AC3R1iVHcjQRDM32hrsd0Rcj2usScZDm/iXrGut9bKahmpRgBFRHUQWnpn/ljtwYgdBX1dg8LaFU+wcfXYSxfITYffCgrt65fNWOW6sfaROhACe7RZuREkl7J5JPw5oQK+mvbmx9VS8bcJnBGqgg14kzRojojC6irfbNuK8+SRkGPlfXAujx3hiGmaECR0sNu1WYB/SYTGTfstOJbLgwgzVlKqzmn/XKAzhIrC+NDdceUt1rZmRzm1DiZueh0G6f1dDY0xjHzRr1woZbRiorjyOXvJzoQSLvopttGRS6hdwe7QwDdzkhc6U4irXLjHzutePqMlWhBeYvG65XVsemmz4txj7Gfb8lOLD95+m0rTekKWcbImwMJrMDuv+O3LsLowfPHBNH9NWZsjXpaK+zzdmgnBaxUyeEu5hbRSZYcNgfVe0fEbs1HmcKApf7uTdFb0nAIj/BsKNXbAGuPsl57PXjLTHNvHNI/wzepqIedfQ20bE+CJCMawgDW05SknlFcIv+09xXKj/tXJ5RMoUQ4ntsd78/epVBi8Y12KYjvwCeJcSKtzNxAcZV5wy+0wmQiL1NobvHKUMwaiBzqNTkqBiJszNfxxd5t4AtDahqDEjrdh5iEyd7IPawA2qyqvPFnfhN7dz4NzS3sAW651k8XG4G6lGl+cGbVJq7Y+SaFIMb/ueh7LfV9YWtDwBK+I7wBU/PB1n0hPVkH4mji24j12LzaXDClxrFFeIZNzKggDzIx4/WQf7SleXbXxp8RCiOwVR/aP9Xp0tLfcvSNMAF2VxrlPKVlnbmFQMHstsBmykUhUQF4vqCw5q8g28zQthEtcCWEPv3kHNMT
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(86362001)(2616005)(16526019)(47076005)(26005)(70586007)(83380400001)(8676002)(44832011)(356005)(36756003)(186003)(2906002)(316002)(956004)(36860700001)(70206006)(5660300002)(966005)(336012)(53546011)(8936002)(40460700001)(16576012)(82960400001)(31686004)(31696002)(82310400004)(6706004)(110136005)(508600001)(81166007)(3940600001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 11:57:22.2804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75381888-08bb-4dec-10fc-08d9d1d4dd2a
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT052.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1214
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 07.01.22 12:10, Yordan Karadzhov wrote:
> Hi Hongzhan and Jan,
> 
> Have you decided something about the way this plugin will be maintained?
> 

No decision yet. I'm still waiting for an answer on
https://lore.kernel.org/linux-trace-devel/9ac9a1af-6829-425a-7943-755decf7c273@gmail.com/
regarding maintenance of different tracepoint revisions. That would be
implicit when keeping the plugin in lock-step with the tracepoints in
the same repo.

But then the question would be how mature the interface lifecycle
management of kernelshark and libs is /wrt external plugins. Those may
need to account for potential changes in those APIs over the time, right?

We will likely pick the path that is least inconvenient.

[...]

>> +    eventFieldIntervalPlot(argvCpp,
>> +                   plugin_ctx->cs_data, checkFieldCS,
>> +                   plugin_ctx->cs_data, checkEntryPid,
>> +                   makeLatencyBox<XenomaiSwitchBox>,
>> +                   {0, 0, 255}, // Blue
> 
> Perhaps you can use 'cobalt blue' instead of just blue ;-)
> 

Makes sense ;)

Seriously: Is there some caption somewhere that explains the meaning of
colors? If so, how to hook into that?

Thanks,
Jan

-- 
Siemens AG, Technology
Competence Center Embedded Linux
