Return-Path: <SRS0=4zaN=V4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B726C32751
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C365206A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Jul 2019 12:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FX8W0dAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfGaMQ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 08:16:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32824 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfGaMQZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 08:16:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so468401pgn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Jul 2019 05:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyS4VsiI5KEbgM5Y9FGwsOe7ua/l91dPj2d8xY9gC5s=;
        b=FX8W0dAN9LEuC0oISccfccGcIVH64CeOzQLj471b8l8HE2PFhj2pxFzkrMb3K2oTNz
         us6VWlJmNb2frXEEB/bxlIqxAyn4HPankWzpX6woOO5mkYaw0GHHW3S3B0c4n80IQ2f6
         59om8Lp7XS8O+JNgMaiWwYWMXKTRQe5TbjG+xBhu8aiIu3QwGTPIuTQ58uREdL+OD1S0
         9ZD2REr9iMpzpNbFF01GqUS2ZZqSDqJuFNW9W5s7qgPs53HJKBQZq88dIRmzgWTQf4cc
         lreiGAw1auw4Esfyh87JZKRqc0Y4pL93Mihe8GJGHwmkGFORz4O5emU/cAVAVYT9pIlv
         SMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyS4VsiI5KEbgM5Y9FGwsOe7ua/l91dPj2d8xY9gC5s=;
        b=itKaI4hxSIKhgoUSQwVymzmQy/p9L5xgUyMlml84igTK3K6/K06+h2+FiKGug0gCNs
         zLrtc2MKHMzbLriBmqUd7HldNTN4wUhi+zYwJ8MziKEO561Rq0mKIs7lCaT/TdF4kl0x
         Swti8sc1N8Ebx2D3YzGt5zlxY7CgYNLiQLqcw05gAS8Sx5ONAPA0gAynQwv86QKfpEAq
         eNTSInsXuE3YA8UjNtWdn0fRPlb1BMQuk9b3mhbxWMiwqH5A5w3n5Xb+p0/hLscvv9bd
         AAn0zFmfQgOSAkshve/BbT0mSt8DPlf/KFJG/hCOiXrtSj+ilY8FNc8HHs8ghYy3lvHc
         DGQQ==
X-Gm-Message-State: APjAAAUqlM4IpFtn2XwDqWBkf1AxUt28atflCiY5o3g3NkXO/vAulGrD
        DCfbDNxKnZVULIyeyhdD2AFXNWzji3TsAksdDK2pCEUtEjY=
X-Google-Smtp-Source: APXvYqzHhCp/TH4NA4wDkGGoOnV4AdmLnjAcQfMME9xAxL+DA46QYja62du85lNPZwPRDVlKCpwWJRVVJHfF7oxI5Vg=
X-Received: by 2002:a63:2b0c:: with SMTP id r12mr113561606pgr.206.1564575385130;
 Wed, 31 Jul 2019 05:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190730125028.24789-1-tz.stoyanov@gmail.com> <20190730125028.24789-2-tz.stoyanov@gmail.com>
 <20190730121245.2d14b2b6@gandalf.local.home>
In-Reply-To: <20190730121245.2d14b2b6@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 31 Jul 2019 15:16:13 +0300
Message-ID: <CAPpZLN7NAnDuvF08B6qAab83cudaEVa=aE=9=oL5pNkUmig5wA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] tools/lib/traceevent, tools/perf: Changes in
 tep_print_event_* APIs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 7:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 30 Jul 2019 15:50:26 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
...
> >  }
> >
> > @@ -5413,18 +5419,20 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
> >  /**
> >   * tep_event_info - parse the data into the print format
> >   * @s: the trace_seq to write to
> > + * @format: printf format string. If any precision is specified in the string,
> > + *       print in raw data format
>
> I'm curious to why this is needed?
>
> We can use a temp trace_seq like I mentioned above, and then apply the
> format to it at the end.
>
We need a way to keep the tep_set_print_raw() functionality with the
new tep_print_event() API.
The user should have an option to print TEP_PRINT_INFO in raw format.
The only way to pass some
extra parameters to tep_print_event() is to use the printf format
string, "%s" in this case.
I choose to use "%s" width specifier to force TEP_PRINT_INFO in raw format.
The other possible solution could be to define a new
TEP_PRINT_INFO_RAW type for this use case.
...

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
