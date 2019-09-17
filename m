Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70009C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BA6921852
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfIQNSC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfIQNSC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:18:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8CA2171F;
        Tue, 17 Sep 2019 13:18:00 +0000 (UTC)
Date:   Tue, 17 Sep 2019 09:17:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stephen Brennan <stephen@brennan.io>
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
Message-ID: <20190917091759.23092874@gandalf.local.home>
In-Reply-To: <41a6b643-ce85-967e-a47f-99c32f1e2d6a@gmail.com>
References: <20190827131418.18713-1-y.karadz@gmail.com>
        <20190828092533.493ce25c@gandalf.local.home>
        <20190828093007.0b0bdabb@gandalf.local.home>
        <41a6b643-ce85-967e-a47f-99c32f1e2d6a@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 17 Sep 2019 13:44:52 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >> This is where I hate C++, because it makes simple things so
> >> complicated ;-)
> >>
> >> What we need to do is simply:
> >>
> >> 	char *str = _commandLineEdit.text();
> >> 	char *last_word = str;
> >> 	char quote = 0;
> >> 	int i;
> >>
> >> 	// remove front and end spaces
> >> 	while (isspace(*str))
> >> 		str++;
> >> 	i = strlen(str);
> >> 	while (i > 0 && isspace(str[i-1])
> >> 		i--;
> >> 	str[i] = 0;  
> > 
> > Oops, need to have:
> > 
> > 	last_word = &str[i];
> > 
> > here.
> > 
> > -- Steve
> >   
> >>
> >> 	for (i = 0; str[i]; i++) {
> >> 		if (isspace(str[i]) && !quote) {
> >> 			str[i++] = 0;
> >> 			argv << last_word;
> >> 			while (isspace(str[i]))
> >> 				i++;
> >> 			last_word = &str[i];
> >> 		}
> >> 		switch(str[i]) {
> >> 		case '\\':
> >> 			i++;
> >> 			break;
> >> 		case '\'':
> >> 		case '"':
> >> 			if (!quote)
> >> 				quote = str[i];
> >> 			else if (quote == str[i])
> >> 				quote = 0;
> >> 			break;
> >> 		}
> >> 	}
> >> 	argv << last_word;
> >>
> >> Note, the above may be buggy, I didn't test it.
> >>  
> 
> Hi Steve,
> 
> I understand very well your feelings ;)
> However, I also really dislike eclectic programming stiles. Since this 
> is part of the C++/Qt code, I would prefer to stick to the C++/Qt way of 
> doing things.

I'm fine with that as you will be maintaining it. But it also needs to
be correct.

> 
> Here is a version of your code that is more C++/Qt-ish:
> 
> 
> 	QString::SplitBehavior opt = QString::SkipEmptyParts;
> 	QChar quote = 0;
> 	int i, progress = 0, size;
> 
> 	cmd.remove(QChar('\\'));

What does the above do? Removes all backslashes? Why? A backslashed
quote must be ignored.

 '\'' is a single quote within quotes.

Not to mention, a backslash keeps whatever it backslashed:

 \$ == $
 \' == '
 \" == "
 \1 == 1
 \\ == \

I don't see how this code handles this, as my code does.

-- Steve


> 	size = cmd.count();
> 	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
> 	for (i = 0; i < size; ++i) {
> 		if (cmd[i] == '\'' || cmd[i] == '"') {
> 			if (quote.isNull()) {
> 				args << lamMid().split(" ", opt);
> 				quote = cmd[i++];
> 				progress = i;
> 			} else if (quote == cmd[i]) {
> 				args << lamMid();
> 				quote = 0;
> 				progress = ++i;
> 			}
> 		}
> 	}
> 
> 	args << cmd.right(size - progress).split(" ", opt);
> 
> If you are OK with this I will send a new version of the patch.
> 
> Thanks!
> Yordan
> 
> 
> 
> >> -- Steve  
> >   

