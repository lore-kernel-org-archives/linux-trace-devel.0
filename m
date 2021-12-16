Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D3AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 07:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhLPHLz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 02:11:55 -0500
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:55264
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234370AbhLPHLz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 02:11:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlQ2Qf0PERswEJaPL7kyi9HJCxAsoltljCUcUN41MZsO7JuRKlWJW0ba4l7QZ+4dbBYQm0ekk3Bhdo82B27iRIh6VDl4eW5bkLrERWIlZSp3egq/ftbq1iA7DwXCoR+Ch02X7b2D31x7avbn0UHkPe+Fjqi28ph2YUbmRG78WTAXfvTmab4h028QgcZCIHn+GajpwdzcUPIdT0EREUr+8wjF2yfLYqqGE3KVENhqumcuIoOrT7jm8LD3VrqHUDxLESbdtK6DW4bjTYBJhqw69YTmyzTZq2npdp/U8kGRSBNwPYj7JSA3jHSggqB44ZEuVV5FyaPKntSNb/oR7FHUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ax8wRpsG89nncdqncOwVS4N/nkpWenuX2+9h15FZXM0=;
 b=TBTrYqHp/qxZE91TOennHxc5ZUA/FgGWaKKdJahwqsNpM5MEdRcct4rJQyFzgoG7ctlLGwapSWA1ledbD2B2IJC6Jx7dsJ1HVdbAluVEjJZauizcEixLB8FIEVMO1n3e5cpJVe1JOhOuDTD61cdSFHdXKlhcvEw8e+Xp0eV4NsMlcWGWiICgM968cmHxXx9EVeMlwqG/cIrXl+TrGALzR/Ov+dE3f/l4fTmPCSKxJx96K7BD+2pDjlOSSOlXe8GO0bTAv2SkBCKXjw2xgTFa6vHHZ0ZmQ+EyzHnwRlFexA+LlqonXTVepbbg/U6jKITSzIg9hc0qmTJkgpO6d77QkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=gmail.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ax8wRpsG89nncdqncOwVS4N/nkpWenuX2+9h15FZXM0=;
 b=DIs1ydzZ9t5FzqRpCRK+n/ytvzR90yb50IEW678Oya1bMjOxlvC/0WULR3p1YOqsga5QpDXYtEuP0y5hJEx11ZQ3+dXPnQqI1A0tRpls5w0LHoIeofkcGrK9M4LfWPqwqXnHQKjRsbUh18IO4Hp9PBFcLVIXSUwscRjPc3QFjAgouLaYri/hqsHj0k0vJE4JhDKey/KXdp5B+gygx9c3gY9xTaRQxI94SwN/4Qrjfrw4h28w1CLTMHV411/NZm7towfCjQLhJy+4tzz54LiuyVr53PAxDaesyj31H93dTU1FpcZulJ48db/wDKykDFes3Mh7zsG8a5LgjjwHFj7fCA==
Received: from DU2PR04CA0314.eurprd04.prod.outlook.com (2603:10a6:10:2b5::19)
 by AM0PR10MB3379.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:156::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 07:11:52 +0000
Received: from DB5EUR01FT042.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:10:2b5:cafe::9) by DU2PR04CA0314.outlook.office365.com
 (2603:10a6:10:2b5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Thu, 16 Dec 2021 07:11:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 DB5EUR01FT042.mail.protection.outlook.com (10.152.5.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.12 via Frontend Transport; Thu, 16 Dec 2021 07:11:52 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 08:11:51 +0100
Received: from [139.22.140.88] (139.22.140.88) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 08:11:51 +0100
Subject: Re: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch.
To:     Steven Rostedt <rostedt@goodmis.org>,
        Hongzhan Chen <hongzhan.chen@intel.com>
CC:     <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
 <20211215220327.0daae29e@gandalf.local.home>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <b4599ebc-7e53-9d95-32ac-448c1cac8a8a@siemens.com>
Date:   Thu, 16 Dec 2021 08:11:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211215220327.0daae29e@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.22.140.88]
X-ClientProxiedBy: DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3120f88-9568-44a9-5c96-08d9c06355d9
X-MS-TrafficTypeDiagnostic: AM0PR10MB3379:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB3379147ECC2F0A45FFEE704795779@AM0PR10MB3379.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTuBUS09/F4R0I32EkMPZRL//ZcdzWWttce6hjmkyrMXU58rshMtEadkuHb504wHqxDTOjgXFnsfKrPUgX71w4OKgy4hKWmzLoso6TVu4+RF/E/gRBUxqzqdJfj0rF29RhkdmhzkhXroUkZoExpsDtaaE/bRqm8avvsBb1ALYnnh/ZjwytS2mjaGRX/aqCqW0I3Syk3NcW0QjEFg3PrcW1wSU7O7G3O547fM0aFPCV5ASRCBZcAQcCz1O3AzCBlxxCZWAK+eYuFM0hbLhlUqzEwZvQ7Gvoey0FMVpwi9M6rJSaUdHEKeiPnOFnMRf26VkC9d0XBMt9GcW/VtFU83aCky2o41YyPe4rQFGx3muDPWR3ZZXMC3zLLk/Lzgce+cVdzO/dq8Xf7vsGAGvU93DimvR7HBdxpt+E23rztDLn5yPn3Y7IZBpdmZPKcNCqpS38pGSRapRSQxGLfs4urWxxf+op3HlKq4/5+rLAro7DhY4sSUcvtiHiH1yTy6gpQv0TnOaHk2P+M4DOjQ6BD/AhnvSBRh7RKNUi+qFcBLlZhDAb96KA7/QZx5jiuj2Ry5XnpgOwbKI30v15tTvuuqSpp3nwoPQWkBlTbD+DsgIvHorkWI95GTsAqDWmslyS+kJjJtXUbrVtlrS27rlO3VThkJwEyEJxJ6V9GiF6NxU6hNL9CQZm3S7L1nqZp83akreJ3lx5SmomnyVvAVgoQ42bg28WgpIUw+MSh85opELpkENhyhOm1o9k3px0jdkPYGUabsHpkayIZXBzzE0qxunx8nW250m+b6uTYKLNmj9smzAcalkTYIGeJl8hWtDxyLGeLl7Db2MYpCGDSG4jJJtRGYH0Pat+PwN4sk+6jTimI=
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(36756003)(8936002)(70586007)(54906003)(82960400001)(356005)(40460700001)(82310400004)(83380400001)(6706004)(47076005)(5660300002)(31686004)(2906002)(44832011)(53546011)(26005)(186003)(36860700001)(4326008)(4744005)(8676002)(81166007)(16526019)(31696002)(110136005)(336012)(956004)(2616005)(16576012)(508600001)(86362001)(316002)(3940600001)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 07:11:52.3458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3120f88-9568-44a9-5c96-08d9c06355d9
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT042.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3379
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 16.12.21 04:03, Steven Rostedt wrote:
> On Wed, 15 Dec 2021 21:16:48 -0500
> Hongzhan Chen <hongzhan.chen@intel.com> wrote:
> 
>> I do not know if this patch can be accepted in upstream from function's
>> view because it is xenomai related which still be different from
>> pure kernel-shark for pure linux. But it is still independent plugin
>> which would not influence other kernel-shark's functions and the plugin
>> would not take effect if there is no cobalt_switch_context event found
>> in trace data.
> 
> We are perfectly happy to accept plugins for various OSs, not just pure
> Linux :-)
> 

We were just wondering how to handle potential (we have no concrete case
so far) variations of trace points along releases of those "various OSs"
best and were therefore also considering maintaining the plugin in
lock-step with the Xenomai releases. How does KernelShark manage such cases?

Thanks,
Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
