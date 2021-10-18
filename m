Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025BCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 19:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01A061351
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 19:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhJRTco (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 15:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhJRTcm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 15:32:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264A1C06161C;
        Mon, 18 Oct 2021 12:30:30 -0700 (PDT)
Date:   Mon, 18 Oct 2021 21:30:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634585428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gVf1lnK84f1nGo5oiwSWEEPmMlFfpTTxKa0gpOyBnJM=;
        b=F90/JWvakT4piDdfpKHS9wWIp0/mwpDQCxJbXipB2tyrdDFh2RGb26pvpvlcyIfXFT6FRB
        pUChGekqWLGAh7E5exAQqz6Bq0WKBY3RWVchukpCeNt8dvij1ZdYAQ8gL3OVTuinfZSGzw
        sPO/rRTDroKcDhTGi+9gI2oB9tpjMrxEUUMqdR1oPygCLUXFliW76knQxN/ihxtCPC7i1Q
        OUI5DR8T7GVcbS0MfYK0Y5TM1QT6hpgrsSOwCVi+LE5x/2fvBGgZl0D7luqxQH7B31bXlh
        87dnVrJYwO6oMmLkbuV7tgsAXh82tzt3c4xWGzjhKwuD3fUEir5YnsrazvyCkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634585428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gVf1lnK84f1nGo5oiwSWEEPmMlFfpTTxKa0gpOyBnJM=;
        b=M+CeOvAE6H5BcQhB25mx7vXwRTLuN0bRFDM9c+MwCRi5QTFwGCoySkA3Tc2P30R77A1IRr
        zn9kTrcBVa61MVAw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 06/19] rtla: Real-Time Linux Analysis tool
Message-ID: <YW3LUhMOVWTvQlKh@lx-t490>
References: <cover.1634574261.git.bristot@kernel.org>
 <65fbb9b508a2c1803bacfe255c1d568eb8f4ba4f.1634574261.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65fbb9b508a2c1803bacfe255c1d568eb8f4ba4f.1634574261.git.bristot@kernel.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Oct 18, 2021, Daniel Bristot de Oliveira wrote:
> --- /dev/null
> +++ b/tools/tracing/rtla/Makefile
> @@ -0,0 +1,59 @@
> +CC	:=	gcc

Some $(CROSS_COMPILE) for the poor souls who will integrate this into
embedded distributions?

> +
> +TRACEFS_HEADERS		:= $$(pkg-config --cflags libtracefs)
> +

ditto. This uses the host's pkg-config unconditionally.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
