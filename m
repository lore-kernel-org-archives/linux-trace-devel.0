Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B295EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Aug 2021 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E70360F55
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Aug 2021 13:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhHANjg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 09:39:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41986 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhHANjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 09:39:36 -0400
Date:   Sun, 1 Aug 2021 15:39:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1627825167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V2DGzvEDDOHL4wNGqLh/L3qbGiCz/WEtxEh6PwuMsKs=;
        b=mr5lb4vnCsZeTua2ZYsa3NKBjB8PegqmeO3YML93vfUO/8iRHIRMWSB81tAILTXQjftSZZ
        QYBVe3gkaZk45qJW0RkryHlJ/T3xps5ioB/fTVhN6ZlnRUu/mnnEMx1Yx6JOF76J2xKCBe
        nRE22EQkvaQQVxHI6p80hBZpFeaiaR7s+L+pW+enzumSv1ZiF9xisZCAt+RtpNom2l/e/c
        oO4yUccLGEDFXX95PriJhteAK0CrZtaQk/mfOtP15cqeyzDxkQciXJ0qY7FTeZfUkB9mx1
        csZG3uL2H7hcJoXUlqom9wEVghREZqnmYFg4ksIksxqWCFt6xQNBVaEmUMkPEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1627825167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V2DGzvEDDOHL4wNGqLh/L3qbGiCz/WEtxEh6PwuMsKs=;
        b=swcnDVMxb+6GHbeFF3VI4TNMHLEgYli8nMjfujvVn5E0hWw8QWQ5CLYcuaQNLazvt2WYWD
        gSQXj6+9IdJsKDDA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 17/17] libtracefs: Add man page for tracefs_sql()
Message-ID: <YQakDYRnId+bK+ue@lx-t490>
References: <20210730221824.595597-1-rostedt@goodmis.org>
 <20210730221824.595597-18-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730221824.595597-18-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 30, 2021, Steven Rostedt wrote:
> +
> +The SQL format is as follows:
> +
> +*SELECT* <fields> FROM <start-event> JOIN <end-event> ON <matching-fields> WHERE <filter>
> +
> +Note, although the examples show the SQL commands in uppercase, they are not required to
> +be so. That is, you can use "SELECT" or "select" or "sElEct".
> +

Maybe it would be helpful to mention that, unlike normal SELECT queries,
the JOIN and ON parts above are _not_ optional?

That is, generic "one event source" queries:

  SELECT common_pid,msr,val FROM write_msr WHERE msr=72

are not supported. (I wish they were though ;-))

BTW, thanks a lot for this work. It will finally make synthetic events
usable!

Kind regards,

--
Ahmed S. Darwish
Linutronix GmbH
