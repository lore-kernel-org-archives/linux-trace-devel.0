Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AA4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 243906124C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344186AbhDFMr3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238988AbhDFMr3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:47:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2276361279;
        Tue,  6 Apr 2021 12:47:21 +0000 (UTC)
Date:   Tue, 6 Apr 2021 08:47:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
Message-ID: <20210406084719.47d19fe6@gandalf.local.home>
In-Reply-To: <CAPpZLN63wz4XoMWmZd=e7jOSXHjgVh9=HhP0PEGKF8yMtDDUzA@mail.gmail.com>
References: <20210405151959.1d6901b2@gandalf.local.home>
        <CAPpZLN63wz4XoMWmZd=e7jOSXHjgVh9=HhP0PEGKF8yMtDDUzA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 6 Apr 2021 12:37:28 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > +
> > +Max line width
> > +==============  
> 
> The desirable max line width should be written here, should we stick
> with the 100 char limit, recently introduced in the Linux kernel ?

Fair point. I actually thought I did mention it. Probably got distracted
and forgot about it.

> 
> > +
> > +This is a guide, as readability is more important than breaking lines up into a
> > +hard limit. Ideally, strings should never be broken up except for where a new
> > +line is added.
> > +
> > +       printf("This is a line that may continue for a very long string.\n"
> > +              "This is another line, but after a new line\n");
> > +
> > +But line breaks should not be:
> > +
> > +       printf("This is a line that may continue for a very"
> > +              "long string.\n This is another line,"
> > +              "but after a new line\n");
> > +
> > +Not only is the above not as readable as the first version, it is not
> > +even equivalent, because it is missing spaces between the line breaks.
> > +For this reason, finish the string on the same line.
> > +
> > +Brackets and baces  
> 
> a typo, should be "braces".

Yep.

> 
> > +==================
> > +
> > +For all conditionals, the braces start on the same line:
> > +
> > +       if (cond) {
> > +       }  
> 
> That extra space before the opening brace should be mentioned in this
> paragraph. As this is something usual for the Linux kernel developers,
> I think it is not widely used by user space C developers.

Ah, like the Linux kernel document that I link to, there's a section alone
on spaces. I left it out thinking that people could read that document, but
perhaps I should add the "Spaces" section as well.

I also forgot to mention when not to use braces:

	if (x)
		y = x;
	else
		y = 1;

	for (i = 0; i < 10; i++)
		foo(i);

Is fine to leave off.

But if there's more than one line, even if it C still allows it, then it
must have braces. And the else part must also match the if part.

 Do not do:

	if (!x)
		for (i = 0; i < 10; i++)
			foo(i);
	else
		foo(x);


 Should be:

	if (!x) {
		for (i = 0; i < 10; i++)
			foo(i);
	} else {
		foo(x);
	}



> 
> > +
> > +And the ending brace is at the same indentation as the conditional.
> > +
> > +       while (cond) {
> > +       }
> > +
> > +       do {
> > +       } while (cond);
> > +
> > +       for (i = 0; i < 10; i++) {
> > +       }
> > +
> > +The same is true for structures:
> > +
> > +       struct my_struct {
> > +               int field;
> > +       };
> > +
> > +But for functions, the baces should start on the following line:
> > +
> > +       void my_function(void)
> > +       {
> > +       }
> > +
> > +
> > +Variable declarations
> > +=====================
> > +
> > +The order of variables that are declared, should first keep the same types
> > +together, but also should be ordered by their length such that the variables
> > +are ordered in an "upside-down Christmas tree" fashion where the length gets
> > +smaller.
> > +
> > +       int tracecmd_count_cpus(void)
> > +       {
> > +               static int once;
> > +               char buf[1024];
> > +               int cpus = 0;
> > +               char *pbuf;
> > +               size_t *pn;
> > +               FILE *fp;
> > +               size_t n;
> > +               int r;
> > +
> > +The above shows that the order is done by length, and in the above example it
> > +also shows that "int cpu = 0;" is not grouped next to "int r;". As this is more
> > +of a guideline and made to be more aesthetic to the eye of the reader, both the
> > +above and is acceptable as below.
> > +
> > +       int tracecmd_count_cpus(void)
> > +       {
> > +               static int once;
> > +               char buf[1024];
> > +               char *pbuf;
> > +               size_t *pn;
> > +               FILE *fp;
> > +               size_t n;
> > +               int cpus = 0;
> > +               int r;
> > +
> > +
> > +Unless variables are tightly related, it is expected that each variable be on
> > +its own line and not grouped by type. That is,
> > +
> > +               int r, cpus = 0;
> > +
> > +is to be discouraged, as the two variables are not related to each other.
> > +But if you had a bunch of counters:
> > +
> > +               int i, j, k;
> > +
> > +That would be fine, as the variables are all related as they are all for the
> > +same purpose (arbitrary counters). The same may go with pointers;
> > +
> > +
> > +       char *begin, *end;
> > +  
> 
> One extra paragraph for arranging the members of a struct will be very
> useful. I still wonder sometimes how to arrange them so the memory
> will be used in a most optimal way.

Although this isn't coding style, its actual programming. But perhaps we
can add a section on that. At least mention using tabs for fields.

	struct {
		int		x;
		int		y;
		unsigned long	z;
	};

> 
> > +Comments
> > +========
> > +
> > +Comments will use the "/* */" format and the C++ "//" style is discouraged.
> > +If a comment is on one line, keep the "/*" and "*/" on the same line:
> > +
> > +       /* This is a single line comment. */
> > +
> > +If a comment spans more than one line, then have the "/*" on a separate line
> > +before the comment and the "*/" on a separate line at the end of the comment,
> > +and each line starts with a "*" where all the "*" line up with each other.
> > +
> > +       /*
> > +        * This is a multi line comment, where all the '*'
> > +        * will line up, and the text is on a separate line
> > +        * as the start and end markers.
> > +        */
> > +
> > +
> > +Function documentation
> > +======================
> > +
> > +All global functions (and especially any APIs) should have a function
> > +description in the form of "kernel doc":
> > +
> > +  https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
> > +
> > +The form is:
> > +
> > +  /**
> > +   * function_name() - Brief description of function.
> > +   * @arg1: Describe the first argument.
> > +   * @arg2: Describe the second argument.
> > +   *        One can provide multiple line descriptions
> > +   *        for arguments.
> > +   *
> > +   * A longer description, with more discussion of the function function_name()
> > +   * that might be useful to those using or modifying it. Begins with an
> > +   * empty comment line, and may include additional embedded empty
> > +   * comment lines.
> > +   *
> > +   * The longer description may have multiple paragraphs.
> > +   *
> > +   * Context: Describes whether the function can sleep, what locks it takes,
> > +   *          releases, or expects to be held. It can extend over multiple
> > +   *          lines.
> > +   * Return: Describe the return value of function_name.
> > +   *
> > +   * The return value description can also have multiple paragraphs, and should
> > +   * be placed at the end of the comment block.
> > +   */
> > +
> > +General
> > +=======
> > +
> > +As stated, this is a guide and may not be strictly enforced. The goal is to
> > +have consistent and readable code. In general, try to have the coding style
> > +match the surrounding code.  
> 
> I agree with Sameer, we should encourage people to use the
> checkpatch.pl script from the kernel tree, before submitting the
> patch. I find this script very useful, should be mentioned here or in
> the CONTRIBUTE file.

I can mention it here, but as I told Sameer, think of both this guide and
checkpatch as just a guide, and not hard requirements. If the fixes from
checkpatch make the code look uglier, it is probably wrong ;-)

-- Steve

