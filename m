Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E13EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Mar 2022 21:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiCAVCI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 16:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiCAVCH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 16:02:07 -0500
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5FB70337
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 13:01:26 -0800 (PST)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 006E64300A
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 15:01:26 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id P9afnFDZERnrrP9afn8Rad; Tue, 01 Mar 2022 14:59:25 -0600
X-Authority-Reason: nr=8
Received: from host-95-232-30-176.retail.telecomitalia.it ([95.232.30.176]:40064 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nP9af-002NW7-A5; Tue, 01 Mar 2022 14:59:25 -0600
Message-ID: <42012169-2d21-73ef-95b7-abd4d2ddf34c@kernel.org>
Date:   Tue, 1 Mar 2022 21:59:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] rtla: Set /dev/cpu_dma_latency to avoid exit from idle
 latencies
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
References: <c74be7f76941cd79404d4dcddd1b8ea2183de38d.1645641162.git.bristot@kernel.org>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <c74be7f76941cd79404d4dcddd1b8ea2183de38d.1645641162.git.bristot@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 95.232.30.176
X-Source-L: No
X-Exim-ID: 1nP9af-002NW7-A5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-232-30-176.retail.telecomitalia.it ([10.0.0.45]) [95.232.30.176]:40064
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/23/22 19:37, Daniel Bristot de Oliveira wrote:
> Set /dev/cpu_dma_latency to 0 to avoid having exit from idle
> states latencies influencing in the analysis.
> 

Sending a v2 of this patch together with a new version of rtla features patch
series.

-- Daniel

