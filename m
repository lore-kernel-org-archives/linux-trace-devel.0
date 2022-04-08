Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7D3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 15:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbiDHPvU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 11:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiDHPvT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 11:51:19 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Apr 2022 08:49:13 PDT
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.184.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15FA393EB
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 08:49:12 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id BC7EB10264
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 10:03:29 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id cq93nELlo22u3cq93nE18s; Fri, 08 Apr 2022 10:03:29 -0500
X-Authority-Reason: nr=8
Received: from host-95-245-33-130.retail.telecomitalia.it ([95.245.33.130]:42398 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1ncq92-0032ym-QE; Fri, 08 Apr 2022 10:03:28 -0500
Message-ID: <1a9ca671-8578-6352-09b1-ac4c546f4e16@kernel.org>
Date:   Fri, 8 Apr 2022 17:03:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] rtla: add a tag to avoid dereferring a NULL pointer
Content-Language: en-US
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     kael_w@yeah.net, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <20220401123948.69312-1-wanjiabing@vivo.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220401123948.69312-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 95.245.33.130
X-Source-L: No
X-Exim-ID: 1ncq92-0032ym-QE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-245-33-130.retail.telecomitalia.it ([10.0.0.45]) [95.245.33.130]:42398
X-Source-Auth: kernel@bristot.me
X-Email-Count: 3
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Wan

There is a typo in the subject, and it needs a capital letter after the ':'.

I suggest using something like:

rtla: Avoid record NULL pointer dereference

Do you mind sending a v3?

On 4/1/22 14:39, Wan Jiabing wrote:
> Fix the following null/deref_null.cocci errors:
> ./tools/tracing/rtla/src/osnoise_hist.c:870:31-36: ERROR: record is NULL but dereferenced.
> ./tools/tracing/rtla/src/osnoise_top.c:650:31-36: ERROR: record is NULL but dereferenced.
> ./tools/tracing/rtla/src/timerlat_hist.c:905:31-36: ERROR: record is NULL but dereferenced.
> ./tools/tracing/rtla/src/timerlat_top.c:700:31-36: ERROR: record is NULL but dereferenced.
> 
> "record" is NULL before calling osnoise_init_trace_tool.
> Add a tag "out_free" to avoid dereferring a NULL pointer.
> 
> Fixes: 51d64c3a1819 ("rtla: Add -e/--event support")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Also adding:

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks,
-- Daniel
