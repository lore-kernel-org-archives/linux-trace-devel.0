Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D75C001DE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 00:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjHIA4U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 20:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjHIA4T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 20:56:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3138F19A1
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 17:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CA862D2E
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 00:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A661FC433C7;
        Wed,  9 Aug 2023 00:56:17 +0000 (UTC)
Date:   Tue, 8 Aug 2023 20:56:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 1/6] histograms: Initial histograms interface
Message-ID: <20230808205615.56d03f53@gandalf.local.home>
In-Reply-To: <20230808215105.GA1258@3xKetch>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-2-stevie.6strings@gmail.com>
        <20230808153547.29b7bc60@gandalf.local.home>
        <20230808215105.GA1258@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 8 Aug 2023 17:51:05 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> On Tue, Aug 08, 2023 at 03:35:47PM -0400, Steven Rostedt wrote:
> > On Tue,  8 Aug 2023 12:11:54 -0400
> > Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> >   
> > > +/*
> > > + * Trace data entry for a traceeval histogram
> > > + * Constitutes keys and values.
> > > + */
> > > +union traceeval_data {
> > > +	char				*string;  
> > 
> > We need to also add:
> > 
> > 	const char			*cstring;
> > 
> > At least for the user interface, as I'm converting task-eval over to this,
> > and I need to assign const strings to this union.  
> 
> I assume I should treat cstring the same as string, execept because it's
> constant, it should not be updated on insertion, correct?

On insertion we have:

static int copy_traceeval_data(struct traceeval_type *type,
				const union traceeval_data *orig,
				union traceeval_data *copy)
{
	*copy = *orig;

	switch (type->type) {
	case TRACEEVAL_TYPE_STRING:
		copy->string = NULL;
		if (orig->string)
			copy->string = strdup(orig->string);
		if (!copy->string)
			return -1;
		break;

	default:
		break;
	}

	return 0;
}

So we copy it. That means we really can do whatever we want to it.

-- Steve
