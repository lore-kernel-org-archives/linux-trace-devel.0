Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C91C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 May 2023 08:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjE2IiZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 May 2023 04:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjE2IiY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 May 2023 04:38:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4565BA7;
        Mon, 29 May 2023 01:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0164561241;
        Mon, 29 May 2023 08:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD402C433EF;
        Mon, 29 May 2023 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685349502;
        bh=UUvMpUK3I9eV29fywupEt0iy4Tb5jD4O6D80VbqUdck=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f3bVL2xGF8sq1rFb1JPb8j+V5VrbIfEkRkwiNFxWDKf8jUy15vGGSI4Ur3RXe6fol
         dVQ5zLlTD5pgvALU2dAVYtx0ESfh6+otksfzlNMBMpZlYa9hv/zeDPl+Fv2MR6Mrnz
         fecAWvMAI0d55fhc6sOZByMQWaqil/Q1/FZsf9maQueFFAG6lpnvKH0e4QbbZ09i+7
         JMhEpRLzAQnUwSTlzcg1MYSlptOiQ6FGkTczuWyOIW8bO9zfM48LoMlAOzwChlf4Lw
         83g5Vyt1oChlmNw5vJxuXVkrsRz9GkLSXtGfM62fRNbym4sPoDn+JP7lS1zwFiM+JO
         9gMrOyr1pSr5Q==
Message-ID: <838075fb-8b82-1aee-97a1-95102c03c16d@kernel.org>
Date:   Mon, 29 May 2023 10:38:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 0/9] rtla improvements
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-doc@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        William White <chwhite@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1684863094.git.bristot@kernel.org>
 <20230529042839.5d4af427@rorschach.local.home>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230529042839.5d4af427@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 5/29/23 10:28, Steven Rostedt wrote:
> Hi Daniel,
> 
> Could you make sure to Cc linux-trace-kernel@vger.kernel.org and not
> linux-trace-devel. The former is for any patch that goes into the
> kernel repo, the later is for the tracing libraries (like libtracefs).
> The reason why this matters is that the patchwork that is associated to
> the Linux kernel tree will not get these (and I will not work on them
> when I'm working on kernel patches). But it will go into the 
> patchwork for the libraries (and never be processed by the patchwork
> infrastructure), and I will likely not work on them, because when I
> look at the library patchwork, I ignore anything that goes into the
> kernel.

Sure, I will do that. IIRC, we agreed that we would use linux-trace-devel for
rtla because it is a user-space tool. But I agree with you, as they are patches
going to the kernel repo, linux-trace-kernel is a better place. It is easier to
myself too... :-).

> 
> Perhaps resend with the proper Cc and it will then be processed. I
> allowed this to happen before, but that's because I did everything
> manually and not with my scripts. And I'm tired of doing that.

I will do that in the v3.

I will also update the maintainers entry for RTLA and RV, as both are pointing to
linux-trace-devel.

Thanks!
-- Daniel

> 
> Thanks,
> 
> -- Steve

