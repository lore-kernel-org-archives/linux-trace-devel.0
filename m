Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFEAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 08:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450542AbiAYIgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 03:36:54 -0500
Received: from gateway24.websitewelcome.com ([192.185.50.84]:19496 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1450756AbiAYIdi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 03:33:38 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 770FF13F9C
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 02:33:38 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id CHGkn8wp522u3CHGkniU5q; Tue, 25 Jan 2022 02:33:38 -0600
X-Authority-Reason: nr=8
Received: from host-79-47-126-144.retail.telecomitalia.it ([79.47.126.144]:33426 helo=[10.0.0.238])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nCHGj-0017BZ-SE; Tue, 25 Jan 2022 02:33:38 -0600
Message-ID: <1c2fe9ac-804e-2068-0800-2cee012b96d3@kernel.org>
Date:   Tue, 25 Jan 2022 09:33:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] docs: Hook the RTLA documents into the kernel docs build
Content-Language: en-US
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <877dau555q.fsf@meer.lwn.net>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <877dau555q.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.47.126.144
X-Source-L: No
X-Exim-ID: 1nCHGj-0017BZ-SE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-47-126-144.retail.telecomitalia.it ([10.0.0.238]) [79.47.126.144]:33426
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 1/21/22 01:00, Jonathan Corbet wrote:
> The RTLA documents were added to Documentation/ but never hooked into the
> rest of the docs build, leading to a bunch of warnings like:
> 
>   Documentation/tools/rtla/rtla-osnoise.rst: WARNING: document isn't included in any toctree
> 
> Add some basic glue to wire these documents into the build so that they are
> available with the rest of the rendered docs.  No attempt has been made to
> turn the RTLA docs into proper RST files rather than warmed-over man pages;
> that is an exercise for the future.
> 
> Fixes: d40d48e1f1f2 ("rtla: Add Documentation")
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks, Jon!

-- Daniel
