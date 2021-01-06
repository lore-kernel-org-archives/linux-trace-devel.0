Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F85AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312822312C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbhAFR3U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbhAFR3Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 12:29:16 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED81823125;
        Wed,  6 Jan 2021 17:28:35 +0000 (UTC)
Date:   Wed, 6 Jan 2021 12:28:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] kernel-shark: Add KS_DOUBLE_SIZE macro
Message-ID: <20210106122834.0c70d68d@gandalf.local.home>
In-Reply-To: <20210106120208.3e212fbd@gandalf.local.home>
References: <20210106161120.119085-1-y.karadz@gmail.com>
        <20210106161120.119085-2-y.karadz@gmail.com>
        <20210106120208.3e212fbd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 6 Jan 2021 12:02:08 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed,  6 Jan 2021 18:11:15 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> > The macro is useful for resizing of dynamic arrays. It is currently
> > used to resize the Data stream descriptor array, owned by the session
> > context. We will later use the macro with the arrays of data fields and
> > plugin contexts.
> > 
> > Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> > ---
> >  src/libkshark-plugin.h | 14 ++++++++++++++
> >  src/libkshark.c        | 15 +++++++--------
> >  2 files changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
> > index 1a642ad..f3c724f 100644
> > --- a/src/libkshark-plugin.h
> > +++ b/src/libkshark-plugin.h
> > @@ -346,6 +346,20 @@ int kshark_handle_dpi(struct kshark_data_stream *stream,
> >  int kshark_handle_all_dpis(struct kshark_data_stream *stream,
> >  			   enum kshark_plugin_actions  task_id);
> >  
> > +/** General purpose macro for resizing dynamic arrays. */  
> 
> Perhaps make this into a static inline function?

Never mind, I see you need the macro due to the "type" field. But we can
shorten this with:

   #define KS_DOUBLE_SIZE(array, size)				\
   ({								\
	ssize_t n = size;					\
	typeof(array) _tmp_ = (typeof(array)) realloc(array, 2 * n * \
                               sizeof(*_tmp_));			\
	if (_tmp_) {						\
		memset(_tmp_ + n, 0, n * sizeof(*_tmp_));	\
		size = 2 * n;					\
		array = _tmp_;					\
		true;						\
	}							\
	false;							\
   })

> FYI, as a macro, to return a value you have:
> 
> #define foo() ({ return true; })

The above is wrong, it should have been:

  #define foo() ({ true; })

-- Steve
