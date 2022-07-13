Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8208EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 21:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiGMVcH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 17:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbiGMVcH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 17:32:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D722B2C;
        Wed, 13 Jul 2022 14:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 562EDB821EC;
        Wed, 13 Jul 2022 21:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FC8C34114;
        Wed, 13 Jul 2022 21:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657747924;
        bh=IoB2gnqcGYCUJ7LQdc6AHM9F4DsPlbrEttgS1z2ppfI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iJ2T6drVKvnjb5hBs0uwqk8PAJsWaOxioTpxAICp7D8jxpbAKBnt7Ew8scQ3eD5kN
         6FJjOVO9h5LGSBJBBjTDdhkYNd6ecEDFVNQYijdjuIkctgLI1Dcs4dSnP3bGE1gr4L
         e3nWs4w5bLXzQLV08CGEfw7k1aYZVo/8mRZq/VnBlQ6BU3hNVwXo/TzgXsrhpO9Ch+
         wvEGbCWY1hkqJCg4l/W3mPpmHHGlskfNi6FlIt10Uc//D6hPBMIAj5AyHz9v3bz2+O
         wEw6EMkuzsJr6GtJeEwGc5yE+YjeOGLSPXdd4A1kg5Uo2YxFS67+yWSi6eUIqLT2O3
         sNfur701LB2wg==
Message-ID: <6bf42d5b-e4a8-63b9-66b2-4d62721c445c@kernel.org>
Date:   Wed, 13 Jul 2022 23:32:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] rtla: Fix Makefile when called from -C tools/
Content-Language: en-US
To:     sedat.dilek@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <9154d66961804027b1bdc26f1ff08012bb7f9df8.1657269675.git.bristot@kernel.org>
 <CA+icZUUKiODjF0gZ1MaHPgVZS8zKEweR-1NkjHcegsLoRNUQ9w@mail.gmail.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <CA+icZUUKiODjF0gZ1MaHPgVZS8zKEweR-1NkjHcegsLoRNUQ9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/10/22 10:40, Sedat Dilek wrote:

Fixing the other comments in the v2... and

>>     $ make -C ../../.. kernelversion | grep -v make
>>     5.19.0-rc4
>>
> Shouldn't that be:
> 
> $ make -sC ... (missing "s")

I did not add the -s here to show that the | grep -v make fixes the problem
when the -s is ignored/bypassed (the cause of this bug).

Sending the v2

(Sorry for the delay Steven)

-- Daniel
