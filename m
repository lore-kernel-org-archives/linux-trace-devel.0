Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803D1EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jul 2023 15:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjGEPE6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjGEPEK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 11:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5761BFC;
        Wed,  5 Jul 2023 08:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26358615D8;
        Wed,  5 Jul 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E408AC433C7;
        Wed,  5 Jul 2023 15:03:04 +0000 (UTC)
Date:   Wed, 5 Jul 2023 11:03:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, dan.carpenter@linaro.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel/trace: Fix cleanup logic of
 enable_trace_eprobe
Message-ID: <20230705110302.2492a550@gandalf.local.home>
In-Reply-To: <CAPpZLN7=m=zMrLz9hwk4TcVJRC42ZsxuwRDjpkUPVxPpMW4v7w@mail.gmail.com>
References: <20230630121627.833560-1-tz.stoyanov@gmail.com>
        <20230701090254.72323659@rorschach.local.home>
        <20230702235001.5bd26b8cd85028fc2bce94e6@kernel.org>
        <CAPpZLN7=m=zMrLz9hwk4TcVJRC42ZsxuwRDjpkUPVxPpMW4v7w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 3 Jul 2023 06:47:12 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Ok, I'll send v3 with the counter, although I think it is a bit
> overengineering - that optimization is in code that is unlikely to be
> executed.

It's not really over-engineering. We have this type of logic all over the
kernel. When rolling back something, you really only want to rollback what
you did, and not more. It prevents future bugs and makes things a bit more
robust.

I'll go pick up v3 now.

Thanks Tzvetomir!

-- Steve
