Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_24_48,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74192C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 00:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCEF61359
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhDFA6N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 20:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhDFA6M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 20:58:12 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A69C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 17:58:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6759227pjv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 17:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6hS/pAms0XBv36/vLuB4i9i7mhS7o15DOQkxxfLYFm0=;
        b=tz4/q6UK2+V7SL9pbwkqQXk9JoVZqv4F2zJuIHOXHOwkzLUqF/YqDSQJzxV2G/SIsx
         I9pgpZcEkOOL/3RTu1vLQoNWM3xExcQdOq7DJW+L8HQQDaiYRfauXoCdtQkQNBnnzG4r
         Za/I9QF/OphcfBSeQUg6JHS7iBX/axmQOGIjDPqnKUWkAqva7l3ITCpdvD9xlVql+Sd0
         eVc5y9/aOT3HmPTSLxuVGfxC5+EFb/TWBZ5qh9JCNLTmprrqq4SSHNgLQVXKZfwMFDkJ
         lNutBwf+/7ze2mAdN2UBk7euAqWMdod1LMoPjcDaHQbK9lkKdDyi/sXiqC7H2JO20t8a
         0gPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6hS/pAms0XBv36/vLuB4i9i7mhS7o15DOQkxxfLYFm0=;
        b=KODsBEeVF6pHLT32m55T5VJ9kVrAMTJ/o0PnVUzbuS/3z+or1mhN4PSL9LdUOq0JBv
         ThNS9+vQ0SLY0UVjXhlXMIXAVtJUldCoY74seoxGKZKe++GhAraBnK9MTa39Hq7lD2gP
         G5znvOEvU9aWnkURsHnewPCpX/+aMIT9yEutTdZ3Vbx73YBWZ8jLZ9KTJoid5RbOHlIw
         k0EvlXRwwWeOUUXzyLSROcWrANhT7E3KXYbgfUCbI+Iyontb/TqnuMhK9+GlDLKA+OME
         3omoTM6Yxn5FiPQL75zrHSp5qLyZJhPlRAi1rLtmjlF6fd8bLonxqg2vg3fNgKn2pCS2
         GYNA==
X-Gm-Message-State: AOAM530wHqR/ByF0yk8a9ZFLFq7y0pFmLb+16jcxOp0O9/kRtLBBSGHP
        5D4xpx/8lYlaMx/rQ+K81u96jRLRa+lfVA==
X-Google-Smtp-Source: ABdhPJwTTKTpdprkA0ZbI2XdfXM1NYdp5nZrtfILFRyWHKPLPJOWDVaqApVuL+qJp0I/AiGkgflMlA==
X-Received: by 2002:a17:902:5601:b029:e9:14b1:50c8 with SMTP id h1-20020a1709025601b02900e914b150c8mr6303165pli.43.1617670683887;
        Mon, 05 Apr 2021 17:58:03 -0700 (PDT)
Received: from [192.168.0.115] ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id m4sm16072516pgu.4.2021.04.05.17.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:58:03 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210405151959.1d6901b2@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <326561d9-81de-76a9-1e0d-f98ad23024d5@gmail.com>
Date:   Wed, 7 Apr 2021 06:28:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210405151959.1d6901b2@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi steve,

On 06/04/21 12:49 am, Steven Rostedt wrote:
> [
>     Hi Sameer,
>     I added you since you are the newest contributor, and would like to know
>     if from your perspective, if these documents would have been helpful
>     to you when you first started to contribute.
>     Thanks!
> ]
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> Add a CODING_STYLE document that describes the expected style of the code
> as well as a CONTRIBUTE document that explains how a new comer can
> contribute to the project.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   CODING_STYLE | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   CONTRIBUTE   |  80 +++++++++++++++++++++++
>   2 files changed, 259 insertions(+)
>   create mode 100644 CODING_STYLE
>   create mode 100644 CONTRIBUTE
>
> diff --git a/CODING_STYLE b/CODING_STYLE
> new file mode 100644
> index 00000000..6aff138e
> --- /dev/null
> +++ b/CODING_STYLE
> @@ -0,0 +1,179 @@
> +
> +trace-cmd coding-style
> +======================
> +
> +The coding style of trace-cmd and the tracing librariers (libtracefs and
> +libtraceevent) are very similar to the Linux kernel coding style:
> +
> +  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst
> +
> +Indentation
> +===========
> +
> +Tabs are used for the start of indentation (the '\t' character), and should be
> +set to 8 characters. Spaces may be used at the end for continued lines where
> +having the start of text line up to braces in the previous line is not
> +divisible by 8.
> +
> +Max line width
> +==============
> +
> +This is a guide, as readability is more important than breaking lines up into a
> +hard limit. Ideally, strings should never be broken up except for where a new
> +line is added.
> +
> +	printf("This is a line that may continue for a very long string.\n"
> +	       "This is another line, but after a new line\n");
> +
> +But line breaks should not be:
> +
> +	printf("This is a line that may continue for a very"
> +	       "long string.\n This is another line,"
> +	       "but after a new line\n");
> +
> +Not only is the above not as readable as the first version, it is not
> +even equivalent, because it is missing spaces between the line breaks.
> +For this reason, finish the string on the same line.
> +
> +Brackets and baces
> +==================
> +
> +For all conditionals, the braces start on the same line:
> +
> +	if (cond) {
> +	}
> +
> +And the ending brace is at the same indentation as the conditional.
> +
> +	while (cond) {
> +	}
> +
> +	do {
> +	} while (cond);
> +
> +	for (i = 0; i < 10; i++) {
> +	}
> +
> +The same is true for structures:
> +
> +	struct my_struct {
> +		int field;
> +	};
> +
> +But for functions, the baces should start on the following line:
> +
> +	void my_function(void)
> +	{
> +	}
> +
> +
> +Variable declarations
> +=====================
> +
> +The order of variables that are declared, should first keep the same types
> +together, but also should be ordered by their length such that the variables
> +are ordered in an "upside-down Christmas tree" fashion where the length gets
> +smaller.
> +
> +	int tracecmd_count_cpus(void)
> +	{
> +		static int once;
> +		char buf[1024];
> +		int cpus = 0;
> +		char *pbuf;
> +		size_t *pn;
> +		FILE *fp;
> +		size_t n;
> +		int r;
> +
> +The above shows that the order is done by length, and in the above example it
> +also shows that "int cpu = 0;" is not grouped next to "int r;". As this is more
> +of a guideline and made to be more aesthetic to the eye of the reader, both the
> +above and is acceptable as below.
> +
> +	int tracecmd_count_cpus(void)
> +	{
> +		static int once;
> +		char buf[1024];
> +		char *pbuf;
> +		size_t *pn;
> +		FILE *fp;
> +		size_t n;
> +		int cpus = 0;
> +		int r;
> +
> +
> +Unless variables are tightly related, it is expected that each variable be on
> +its own line and not grouped by type. That is,
> +
> +		int r, cpus = 0;
> +
> +is to be discouraged, as the two variables are not related to each other.
> +But if you had a bunch of counters:
> +
> +		int i, j, k;
> +
> +That would be fine, as the variables are all related as they are all for the
> +same purpose (arbitrary counters). The same may go with pointers;
> +
> +
> +	char *begin, *end;
> +
> +Comments
> +========
> +
> +Comments will use the "/* */" format and the C++ "//" style is discouraged.
> +If a comment is on one line, keep the "/*" and "*/" on the same line:
> +
> +	/* This is a single line comment. */
> +
> +If a comment spans more than one line, then have the "/*" on a separate line
> +before the comment and the "*/" on a separate line at the end of the comment,
> +and each line starts with a "*" where all the "*" line up with each other.
> +
> +	/*
> +	 * This is a multi line comment, where all the '*'
> +	 * will line up, and the text is on a separate line
> +	 * as the start and end markers.
> +	 */
> +
> +
> +Function documentation
> +======================
> +
> +All global functions (and especially any APIs) should have a function
> +description in the form of "kernel doc":
> +
> +  https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
> +
> +The form is:
> +
> +  /**
> +   * function_name() - Brief description of function.
> +   * @arg1: Describe the first argument.
> +   * @arg2: Describe the second argument.
> +   *        One can provide multiple line descriptions
> +   *        for arguments.
> +   *
> +   * A longer description, with more discussion of the function function_name()
> +   * that might be useful to those using or modifying it. Begins with an
> +   * empty comment line, and may include additional embedded empty
> +   * comment lines.
> +   *
> +   * The longer description may have multiple paragraphs.
> +   *
> +   * Context: Describes whether the function can sleep, what locks it takes,
> +   *          releases, or expects to be held. It can extend over multiple
> +   *          lines.
> +   * Return: Describe the return value of function_name.
> +   *
> +   * The return value description can also have multiple paragraphs, and should
> +   * be placed at the end of the comment block.
> +   */
> +
> +General
> +=======
> +
> +As stated, this is a guide and may not be strictly enforced. The goal is to
> +have consistent and readable code. In general, try to have the coding style
> +match the surrounding code.
> diff --git a/CONTRIBUTE b/CONTRIBUTE
> new file mode 100644
> index 00000000..f03d00d8
> --- /dev/null
> +++ b/CONTRIBUTE
> @@ -0,0 +1,80 @@
> +If you like to become part of the community and submit patches, here's how
> +to do so for trace-cmd.
> +
> +If you only want to report a bug, or suggest an enhancement, you may do
> +so at:
> +
> +  https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark
> +
> +All development is done via a mailing list:
> +
> +   http://vger.kernel.org/vger-lists.html#linux-trace-devel
> +
> +Patches should be sent to linux-trace-devel@vger.kernel.org
> +
> +Start by cloning the official repository:
> +
> +  git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
> +
> +Make your changes. When you are satisfied with them, commit them into git.
> +Here's some helpful hints for your git commits.
> +
> +1) When making changes, please follow the coding style defined by the file
> +   called CODING_STYLE in this directory.
> +
> +2) Every commit should only do one thing.
> +   That is, if your work requires some cleaning up of code, do that
> +   clean up as a separate commit and not with your functional changes.
> +   Find ways to take "steps" in modifying code. If you can break up
> +   your changes in a series of steps, do so.
> +
> +3) The commit log should start with a title. Like the below
> +
> +      trace-cmd: Add CONTRIBUTE file
> +
> +   Even though this repo is for trace-cmd, start the topic with
> +   "trace-cmd:" because the commits will end up as patches to a mailing
> +   list that handles other tracing repos, differentiating them with the subject
> +   is useful. You can be more specific as well. If the change only affects the
> +   "record" command, you may start the title with "trace-cmd record:".
> +
> +4) The body of the commit (with a blank line from the title), should be self
> +   contained, and explain why you are making the change. The title should hold
> +   the "what" is changing, but the body contains the rationale for the change.
> +   It should be a stand alone, and not state things like "See the next patch",
> +   because when it is in git history, there's no knowing what the next patch
> +   is.  You can make statements like "This is needed for a <future-feature>
> +   that will come later". Where "<future-feature>" is something that you are
> +   working on and the current commit is one of the steps required to get there.
> +
> +5) Add your Developer Certificate of Origin (DCO) at the bottom of the commit
> +   log. That is "Signed-off-by: Full Name <email>" where your full name is your
> +   real name (no pseudonyms). Optionally, if you are making the change on
> +   behalf of your company, you may also add your company name, if you are not
> +   using your company's email. "Signed-off-by: Full Name (Company) <email>".
> +   Please note, the DCO is your statement that you have the legal right to
> +   make these changes for the project you are submitting to.
> +
> +Finally, you can use the git "send-email" functionality:
> +
> +  git --send-email --from='<your-email> --to='linux-trace-devel@vger.kernel.org' HEAD~1..HEAD
I think, we should add a line about "checking the patch using the 
checkpatch script, before sending the email", what you say?

Another suggestion is,

we should document about, how to apply the mailing list patches, which 
are not yet mainlined. people can search in the internet, but different 
forums will give different approaches.

> +
> +If you are sending one patch, if you are adding more than one patch, also include
> +a cover letter:
> +
> +  git --send-email --cover-letter --annotate --from='<your-email> --to='linux-trace-devel@vger.kernel.org' <first-commit>~1..HEAD
> +
> +If you receive feedback on your patches, and plan on sending another version,
> +please use the '-v' option to mark your patches that they are a new version.
> +For example, if you add "-v2" to the above commands, instead of having:
> +"[PATCH]" in the subject, it will have "[PATCH v2]", letting the reviewers know
> +that this is a new version. If you send another version, use "-v3" and so on.
> +
> +For more information about git --send-email:
> +
> +  https://git-scm.com/docs/git-send-email
> +
> +To keep track of the status of patches that have been submitted, check out:
> +
> +  https://patchwork.kernel.org/project/linux-trace-devel/list/
> +

