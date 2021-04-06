Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2380C43460
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 09:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58B5613E4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 09:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhDFJhx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 05:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbhDFJhw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 05:37:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A23C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 02:37:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so3426854pjb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 02:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QSibWftq4h+4Y5/3WRehMuH4UJEDWpksUtWF9OHVMr8=;
        b=OKsbFPtxT+1FnjvJiTzV90qZFzbOdyjS9s03nwLZkkQOII3WNht0myCJy4zLDpW0Rh
         X3ETZwV9FpzcL8WiRp9HfUwdXskEkA4q+WTY8nZmhZT4SnJa19/n+5Aj9uDzzzKkSGaG
         BSTH75LY1+06QZ8n2FLxUZ6bm4IY7YLfZECeVmblxKIKA4qcZT1jJhcR4L3FKYEieiCu
         q48G88433bvbLcHk9kOaZFfpVBxUKvOnSO29yqQqPd67Rp2pr+Jjzm5EDnyqDd6sP2E5
         M+1q3U6wBRNXx0SwBIGBA7XuMf4kwyAr4norC90a7GETR09smnp0CFIVmFJvE27ZHZvH
         pgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QSibWftq4h+4Y5/3WRehMuH4UJEDWpksUtWF9OHVMr8=;
        b=V6R7Q0+fpC++nK2kMWmo6knQDMTm4iIQ13JRIEeFgZbLNk49ZBmZBVK/FXfL9a0lqy
         0y6BrNfQpqw664bLmDYZkdBKfAcHJxVpQutTyBMsniFS9aip8QR5z0oeyuEY0uyBV1cJ
         /D/O1HoSMjn2RUQBfMZqCjSlERToU47xc/8cEPPdR6/3NG8idTaoBCvEMePahAoGwf6/
         ZF2KL0USnATx242sUXKucQPRHe99cX4NzQiR9zB1iZ6+IEvUVXBk4JKRM4qU6bcKlqDH
         2POFQ0+IWwdZb4FS7UjseEsY/Rf0t/8a2jmpzQY5jT6p2U3aLNmJhRmzgDbOMm3WAu99
         kmlg==
X-Gm-Message-State: AOAM5306z92wpcCgtekQJpBFzOqmIkz7j/WrzKuGOo/qXlKOb56RSFJC
        DYCrHjwV80Czvu+vwt348QmAxy2Fz7VLrPZL5tKWCzkWPGi+Lg==
X-Google-Smtp-Source: ABdhPJy5vmIeZSO/fTPII3Y0n32KYWmz0JuMpOP7o4WcgOk+qMLkiOgqoyZfxPFJk9orTzMVdFlh0OJLVJiR5ir7C8s=
X-Received: by 2002:a17:90a:6343:: with SMTP id v3mr3447479pjs.153.1617701864895;
 Tue, 06 Apr 2021 02:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210405151959.1d6901b2@gandalf.local.home>
In-Reply-To: <20210405151959.1d6901b2@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 6 Apr 2021 12:37:28 +0300
Message-ID: <CAPpZLN63wz4XoMWmZd=e7jOSXHjgVh9=HhP0PEGKF8yMtDDUzA@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,
I have a few suggestions:

On Tue, Apr 6, 2021 at 10:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> [
>    Hi Sameer,
>    I added you since you are the newest contributor, and would like to know
>    if from your perspective, if these documents would have been helpful
>    to you when you first started to contribute.
>    Thanks!
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
>  CODING_STYLE | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  CONTRIBUTE   |  80 +++++++++++++++++++++++
>  2 files changed, 259 insertions(+)
>  create mode 100644 CODING_STYLE
>  create mode 100644 CONTRIBUTE
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

The desirable max line width should be written here, should we stick
with the 100 char limit, recently introduced in the Linux kernel ?

> +
> +This is a guide, as readability is more important than breaking lines up into a
> +hard limit. Ideally, strings should never be broken up except for where a new
> +line is added.
> +
> +       printf("This is a line that may continue for a very long string.\n"
> +              "This is another line, but after a new line\n");
> +
> +But line breaks should not be:
> +
> +       printf("This is a line that may continue for a very"
> +              "long string.\n This is another line,"
> +              "but after a new line\n");
> +
> +Not only is the above not as readable as the first version, it is not
> +even equivalent, because it is missing spaces between the line breaks.
> +For this reason, finish the string on the same line.
> +
> +Brackets and baces

a typo, should be "braces".

> +==================
> +
> +For all conditionals, the braces start on the same line:
> +
> +       if (cond) {
> +       }

That extra space before the opening brace should be mentioned in this
paragraph. As this is something usual for the Linux kernel developers,
I think it is not widely used by user space C developers.

> +
> +And the ending brace is at the same indentation as the conditional.
> +
> +       while (cond) {
> +       }
> +
> +       do {
> +       } while (cond);
> +
> +       for (i = 0; i < 10; i++) {
> +       }
> +
> +The same is true for structures:
> +
> +       struct my_struct {
> +               int field;
> +       };
> +
> +But for functions, the baces should start on the following line:
> +
> +       void my_function(void)
> +       {
> +       }
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
> +       int tracecmd_count_cpus(void)
> +       {
> +               static int once;
> +               char buf[1024];
> +               int cpus = 0;
> +               char *pbuf;
> +               size_t *pn;
> +               FILE *fp;
> +               size_t n;
> +               int r;
> +
> +The above shows that the order is done by length, and in the above example it
> +also shows that "int cpu = 0;" is not grouped next to "int r;". As this is more
> +of a guideline and made to be more aesthetic to the eye of the reader, both the
> +above and is acceptable as below.
> +
> +       int tracecmd_count_cpus(void)
> +       {
> +               static int once;
> +               char buf[1024];
> +               char *pbuf;
> +               size_t *pn;
> +               FILE *fp;
> +               size_t n;
> +               int cpus = 0;
> +               int r;
> +
> +
> +Unless variables are tightly related, it is expected that each variable be on
> +its own line and not grouped by type. That is,
> +
> +               int r, cpus = 0;
> +
> +is to be discouraged, as the two variables are not related to each other.
> +But if you had a bunch of counters:
> +
> +               int i, j, k;
> +
> +That would be fine, as the variables are all related as they are all for the
> +same purpose (arbitrary counters). The same may go with pointers;
> +
> +
> +       char *begin, *end;
> +

One extra paragraph for arranging the members of a struct will be very
useful. I still wonder sometimes how to arrange them so the memory
will be used in a most optimal way.

> +Comments
> +========
> +
> +Comments will use the "/* */" format and the C++ "//" style is discouraged.
> +If a comment is on one line, keep the "/*" and "*/" on the same line:
> +
> +       /* This is a single line comment. */
> +
> +If a comment spans more than one line, then have the "/*" on a separate line
> +before the comment and the "*/" on a separate line at the end of the comment,
> +and each line starts with a "*" where all the "*" line up with each other.
> +
> +       /*
> +        * This is a multi line comment, where all the '*'
> +        * will line up, and the text is on a separate line
> +        * as the start and end markers.
> +        */
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

I agree with Sameer, we should encourage people to use the
checkpatch.pl script from the kernel tree, before submitting the
patch. I find this script very useful, should be mentioned here or in
the CONTRIBUTE file.

[..]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
