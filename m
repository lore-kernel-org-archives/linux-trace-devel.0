Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC20C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 16:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0CDC22BF3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 16:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgLIQfT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 11:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgLIQfS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 11:35:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11EE222BF3;
        Wed,  9 Dec 2020 16:34:37 +0000 (UTC)
Date:   Wed, 9 Dec 2020 11:34:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark: Add support for drawing text
Message-ID: <20201209113436.6782bf6a@gandalf.local.home>
In-Reply-To: <aebedfc4-1f00-11a0-7c20-61eb927d96e0@gmail.com>
References: <20201120095031.271735-1-y.karadz@gmail.com>
        <20201120095031.271735-2-y.karadz@gmail.com>
        <20201204183127.186a7f87@gandalf.local.home>
        <aebedfc4-1f00-11a0-7c20-61eb927d96e0@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Dec 2020 15:30:38 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >> +		stbtt_GetBakedQuad(font->cdata,
> >> +				   KS_FONT_BITMAP_SIZE,
> >> +				   KS_FONT_BITMAP_SIZE,
> >> +				   *text - KS_SPACE_CHAR,
> >> +				   &x, &y,
> >> +				   &quad,
> >> +				   1);
> >> +
> >> +		glTexCoord2f(quad.s0, quad.t1);
> >> +		glVertex2f(quad.x0, quad.y1);
> >> +
> >> +		glTexCoord2f(quad.s1, quad.t1);
> >> +		glVertex2f(quad.x1, quad.y1);
> >> +
> >> +		glTexCoord2f(quad.s1, quad.t0);
> >> +		glVertex2f(quad.x1, quad.y0);
> >> +
> >> +		glTexCoord2f(quad.s0, quad.t0);
> >> +		glVertex2f(quad.x0, quad.y0);  
> > 
> > How is the x and y moved to the next location?  
> 
> Actually the "y" does not change at all here, because for the moment we 
> can't draw multi-line text. "x" gets incremented inside 
> stbtt_GetBakedQuad(). The horizontal advance of the character is used to 
> calculate the new position.

A comment next to that should be stated.

	/* x is incremented here to a new position */
	stbtt_GetBakedQuad(....)


-- Steve
