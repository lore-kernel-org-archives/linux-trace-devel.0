Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F55CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 12:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiCaMxB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 08:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiCaMxB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 08:53:01 -0400
X-Greylist: delayed 1410 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 05:51:14 PDT
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569FEBC5
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 05:51:13 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 79BEEFA8E09
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 07:27:42 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id ZttunNcxq22u3Zttuna9au; Thu, 31 Mar 2022 07:27:42 -0500
X-Authority-Reason: nr=8
Received: from host-79-43-204-123.retail.telecomitalia.it ([79.43.204.123]:33844 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nZttt-003gUe-U1; Thu, 31 Mar 2022 07:27:42 -0500
Message-ID: <f3bfc577-181f-6b5b-b6ff-30edd90bbe83@kernel.org>
Date:   Thu, 31 Mar 2022 14:27:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] rtla/osnoise: avoid NULL pointer dereference on out
Content-Language: en-US
To:     Haowen Bai <baihaowen@meizu.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1648623748-8833-1-git-send-email-baihaowen@meizu.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <1648623748-8833-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.43.204.123
X-Source-L: No
X-Exim-ID: 1nZttt-003gUe-U1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-43-204-123.retail.telecomitalia.it ([10.0.0.45]) [79.43.204.123]:33844
X-Source-Auth: kernel@bristot.me
X-Email-Count: 7
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 3/30/22 09:02, Haowen Bai wrote:
> record is NULL and go out but dereference record->trace.
> 
> report by coccicheck:
> tools/tracing/rtla/src/osnoise_top.c:650:31-36: ERROR:
> record is NULL but dereferenced.

Duplicated of:
https://lore.kernel.org/lkml/20220322113253.57390-1-wanjiabing@vivo.com/

-- Daniel
