Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E29C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376836AbiDTIms (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376822AbiDTImq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:42:46 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3469F646C;
        Wed, 20 Apr 2022 01:40:01 -0700 (PDT)
Received: from localhost (mdns.lwn.net [45.79.72.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2A1DA536;
        Wed, 20 Apr 2022 08:39:59 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 2A1DA536
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1650444000; bh=OnN39R9Apu7YvIQoa0s8yg2B9NbuSBGKFjgbCsdXhHw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=V1zs1SBe2oZKWhPzw8DJaL9G0DdbtcHxoGotyLOq9dwIrMnp42pyhAxlnsA3Galms
         WLeUfL8EcM5XHUb1dq+Txxv/HU5FJbTy9YH0Bi7MRXtFelks0ET1t1U0KPUu+OS5Y1
         6G1s1YZ+Vc6HZl0mIxeMIkYNQgDieuZl/kJyaCSnDq6bxXVUkfvHBfKOIkSs+fc02+
         OPj1z2PgAgo8U8Scboy3ARWnQKXoTYzmYzY6VvcRoB81drDC20+5sPAjz0TBcf7aax
         LnvcIMELiYtaCrrEqM87bSkZ5J5dOaCwXq0o//tXkOcCOYxA2No6i9VQQ30ns81454
         IxtkNa4rMmayg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] rtla: Documentation: fix email addresses
In-Reply-To: <20220418011450.11821-1-rdunlap@infradead.org>
References: <20220418011450.11821-1-rdunlap@infradead.org>
Date:   Wed, 20 Apr 2022 02:39:57 -0600
Message-ID: <87fsm84082.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> Correct lkml@vger to linux-kernel@vger.
> Add linux-trace-devel since that is what is in the MAINTAINERS file.
>
> Fixes: d40d48e1f1f2 ("rtla: Add Documentation")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> ---
>  Documentation/tools/rtla/common_appendix.rst |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/Documentation/tools/rtla/common_appendix.rst
> +++ b/Documentation/tools/rtla/common_appendix.rst
> @@ -1,6 +1,7 @@
>  REPORTING BUGS
>  ==============
> -Report bugs to <lkml@vger.kernel.org>
> +Report bugs to <linux-kernel@vger.kernel.org>
> +and <linux-trace-devel@vger.kernel.org>

Applied, thanks.

jon
