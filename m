Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BEFC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 13:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C102077B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 13:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfH1NZg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfH1NZg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 09:25:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD152077B;
        Wed, 28 Aug 2019 13:25:34 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:25:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stephen Brennan <stephen@brennan.io>
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
Message-ID: <20190828092533.493ce25c@gandalf.local.home>
In-Reply-To: <20190827131418.18713-1-y.karadz@gmail.com>
References: <20190827131418.18713-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Aug 2019 16:14:18 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +	cmdTmp = _commandLineEdit.text();
> +	if (!cmdTmp.contains('\'') && !cmdTmp.contains('\"')) {
> +		/* Split all command line arguments. */
> +		argv << cmdTmp.split(" ", opt);
> +	} else {
> +		int iOpenQuots, iCloseQuots, size = cmdTmp.size();
> +		int iSingleQuots = (cmdTmp.count('\'') == 2) ? cmdTmp.indexOf('\'') : size;
> +		int iDoubleQuots = (cmdTmp.count('\"') == 2) ? cmdTmp.indexOf('\"') : size;
> +
> +		if (iSingleQuots < iDoubleQuots) {
> +			iOpenQuots = iSingleQuots;
> +			iCloseQuots = cmdTmp.lastIndexOf('\'') + 1;
> +		} else if (iDoubleQuots < iSingleQuots) {
> +			iOpenQuots = iDoubleQuots;
> +			iCloseQuots = cmdTmp.lastIndexOf('\"') + 1;
> +		} else {
> +			emit print("\nERROR: Unable to parse the command.");
> +			return {};
> +		}
> +
> +		/* Split the arguments. */
> +		argv << cmdTmp.left(iOpenQuots).split(" ", opt);
> +
> +		/* Everything in between the quotation marks goes in one piece. */
> +		argv << cmdTmp.mid(iOpenQuots, iCloseQuots - iOpenQuots);
> +
> +		/* Split the rest of the arguments. */
> +		argv << cmdTmp.right(size - iCloseQuots).split(" ", opt);
> +	}

This is where I hate C++, because it makes simple things so
complicated ;-)

What we need to do is simply:

	char *str = _commandLineEdit.text();
	char *last_word = str;
	char quote = 0;
	int i;

	// remove front and end spaces
	while (isspace(*str))
		str++;
	i = strlen(str);
	while (i > 0 && isspace(str[i-1])
		i--;
	str[i] = 0;

	for (i = 0; str[i]; i++) {
		if (isspace(str[i]) && !quote) {
			str[i++] = 0;
			argv << last_word;
			while (isspace(str[i]))
				i++;
			last_word = &str[i];
		}
		switch(str[i]) {
		case '\\':
			i++;
			break;
		case '\'':
		case '"':
			if (!quote)
				quote = str[i];
			else if (quote == str[i])
				quote = 0;
			break;
		}
	}
	argv << last_word;

Note, the above may be buggy, I didn't test it.

-- Steve
