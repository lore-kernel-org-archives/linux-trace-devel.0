Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E250AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jul 2022 12:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbiGTMdq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240987AbiGTMdd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 08:33:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C4448E92
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jul 2022 05:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31070615B7
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jul 2022 12:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4FFC3411E;
        Wed, 20 Jul 2022 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658320363;
        bh=BctuJg6AV4ixukR5ds+P4wSzuulJ002pJoOaScm+Ock=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=KxagCprNj+7WrXKlZOMFBS4FAGpyWXlgY+jpFcs4LOF/3LzvIa2/QXVYZl1Wez8GB
         KmLNcc+/c3HTl5uqE1oWTCallFJg05sBcwfREguaOs8Lh+npHi90ZAZ8GEiYMiQrvB
         ej8CA/poZzOhJkw27g6mtbeI48JDpGBYwPM8wRpaI+h1VO5J+uKnh/gfoURjgn/D9n
         B5Zp4nPUASg1kLd5zVARiiGm6UUmR+u6WlVqLfL0xZCpUdafiOKpnP6+BVl4VrH/Rk
         k2HUdHw+sprqYWV4TGk5OMAC/mrzumeaKeuyucYYMwfSyktzB7mn8CQa98S4DaRVlS
         G1pPVhW3rijCA==
Message-ID: <b07f14bb-9771-2a7a-1e46-54c22e52c39a@kernel.org>
Date:   Wed, 20 Jul 2022 14:32:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] tools/rtla: Build with EXTRA_{C,LD}FLAGS
Content-Language: en-US
To:     Ben Hutchings <benh@debian.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <YtLBshz0nMQ7530H@decadent.org.uk>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YtLBshz0nMQ7530H@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/16/22 15:48, Ben Hutchings wrote:
> To allow for distributions and other builders to apply hardening
> policy and other customisation, append EXTRA_CFLAGS and EXTRA_LDFLAGS
> to the corresponding variables.
> 
> Signed-off-by: Ben Hutchings <benh@debian.org>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel
