Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B0CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Oct 2022 12:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJLMvu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 08:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJLMvt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 08:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC1BB2D9A;
        Wed, 12 Oct 2022 05:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCCA3B81A84;
        Wed, 12 Oct 2022 12:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C27C433C1;
        Wed, 12 Oct 2022 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665579105;
        bh=1v6VsgWWJMhTeLPSeZwHMGLzy5xTUH1JKNIjGkBCVoQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jnbYZgZHF0yUPthRu+mfs2QOAtxbKNLqGFMVZ2gOk0Zhmh6SAZt1CAUUzenUnQmJd
         6d8t5pGQn0WlQVnHlNvfwH7S66g5GDhDtxnBBg6yFnFUWdTlJ6FsiY4AKVEJ9TxidW
         dNzAF44lC2FVAhH56TKCwd/WYzINlSjus1deZfYVGiOmQAW5cFupIVqnI25XckvFDC
         65RjbQh8XiHoHG/UcUf1MBP1Rv65xXJ6FYpZ8lxJ/N7N8Wvn+Ad8ekAth7eWm2gkyh
         9W9+CdwTZctBb3Y/PxgbVWFN9mF1keu19J88eLJoDbvQ/DQ6eq5WIZyDrgizoDSqTY
         fknizFIMU/WGg==
Message-ID: <549e73bb-dcf8-7107-aff0-ff4f80d13db6@kernel.org>
Date:   Wed, 12 Oct 2022 14:51:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] Documentation: rtla: Correct command line example
To:     Pierre Gondois <pierre.gondois@arm.com>,
        linux-kernel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20221006084409.3882542-1-pierre.gondois@arm.com>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20221006084409.3882542-1-pierre.gondois@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/6/22 10:44, Pierre Gondois wrote:
> The '-t/-T' parameters seem to have been swapped:
> -t/--trace[=file]: save the stopped trace
> to [file|timerlat_trace.txt]
> -T/--thread us: stop trace if the thread latency
> is higher than the argument in us

I swapped them during the development, but it seems that I got the example
before swapping them :-).

> Swap them back.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel
