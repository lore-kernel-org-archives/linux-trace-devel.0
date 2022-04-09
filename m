Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8EAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Apr 2022 17:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242873AbiDIRbn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 13:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiDIRbm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 13:31:42 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEB083B26
        for <linux-trace-devel@vger.kernel.org>; Sat,  9 Apr 2022 10:29:34 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 6A20C4629
        for <linux-trace-devel@vger.kernel.org>; Sat,  9 Apr 2022 12:29:34 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id dEtyn1WCDb6UBdEtynpYCt; Sat, 09 Apr 2022 12:29:34 -0500
X-Authority-Reason: nr=8
Received: from host-95-245-33-130.retail.telecomitalia.it ([95.245.33.130]:38022 helo=[192.168.0.89])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1ndEtx-004Ng6-RW; Sat, 09 Apr 2022 12:29:34 -0500
Message-ID: <90b3fa39-0e35-2ee1-773e-8d51006c73fa@kernel.org>
Date:   Sat, 9 Apr 2022 19:29:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] rtla: Minor grammar fix for rtla README
Content-Language: en-US
To:     John Kacur <jkacur@redhat.com>
Cc:     RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220408161012.10544-1-jkacur@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220408161012.10544-1-jkacur@redhat.com>
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
X-Exim-ID: 1ndEtx-004Ng6-RW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-245-33-130.retail.telecomitalia.it ([192.168.0.89]) [95.245.33.130]:38022
X-Source-Auth: kernel@bristot.me
X-Email-Count: 3
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 4/8/22 18:10, John Kacur wrote:
> - Change to "The rtla meta-tool includes"
> - Remove an unnecessary "But, "
> - Adjust the formatting of the paragraph resulting from the changes.
> - Simplify the wording for the libraries and tools.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel
