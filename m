Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999BEC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 23:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76EFB60EE8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 23:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhHBXqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 19:46:03 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:41957 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhHBXqD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 19:46:03 -0400
Received: by mail-lf1-f43.google.com with SMTP id y34so36708844lfa.8;
        Mon, 02 Aug 2021 16:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DDJoM53yN36OgzitAqAsau8ApxCChNuxlo7OV5in/g0=;
        b=tckkZ/PSSsWuQzDam4nJUb0m5U8cWjfZEHOJF+KXrRkqwjbpi/TD9ogtoLbLPpGPat
         ePNj7fMBg9Cey1Q9wmL43pGVy0jKjDG/3AO+EzKNcCgJgT6BZZXMhCTxexlb5HcX9Chv
         M7mpbPMyvnclFrb3LJ/kcU855FX6nLEDc4tplaJvzbyKM2iAppi38Gf3aOJdlsl1JV2G
         tFzE58VkCSv53mV7HY+m4zmPjRTnnQytozxjtRcjgFONIJzLLcgVkXQxzug3qicov8qw
         XetOwLsKulp3QzDSRllQ3z4lIVl/C1oWDL00oz0b85q6nH2LoXGZv6IYYph3KFi+c+nu
         L4cA==
X-Gm-Message-State: AOAM532FEDyat9bjGd+Q3BN5hZirBiC00rEZ0K3oEKePv8yWc6Hvlrfu
        P4d1odcGm29eSE/G/MuxfmPucQEv1349VHIbj2s=
X-Google-Smtp-Source: ABdhPJydnkK7LHhvp4Hjf80oou5xSOV7cWN0SrTK/4njm+i/Qfe45erzKp/8a+plsnrbZraU5Jj87ecMFydTAqp1zH0=
X-Received: by 2002:a05:6512:20e:: with SMTP id a14mr14202507lfo.112.1627947950957;
 Mon, 02 Aug 2021 16:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210730221824.595597-1-rostedt@goodmis.org> <20210730221824.595597-2-rostedt@goodmis.org>
In-Reply-To: <20210730221824.595597-2-rostedt@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Mon, 2 Aug 2021 16:45:39 -0700
Message-ID: <CAM9d7cieXRLU3huWVSha-A=CvumEFq59QU_pXYDkeBNS3m_mRA@mail.gmail.com>
Subject: Re: [PATCH 01/17] libtracefs: Added new API tracefs_sql()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Fri, Jul 30, 2021 at 3:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> This adds the API tracefs_sql() that takes a tep_handle handler, a name,
> and a SQL string and parses it to produce a tracefs_synth synthetic event
> handler.
>
> Currently it only supports simple SQL of the type:
>
>   SELECT start.common_pid AS pid, end.common_timestamp.usecs AS usecs
>     FROM sched_waking AS start on sched_switch AS end
>     ON start.pid = end.next_pid
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---

[SNIP]
> diff --git a/src/sqlhist.l b/src/sqlhist.l
> new file mode 100644
> index 000000000000..3f394f37b738
> --- /dev/null
> +++ b/src/sqlhist.l
> @@ -0,0 +1,88 @@
> +%{
> +/* code here */
> +
> +#include <stdarg.h>
> +#include "sqlhist-parse.h"
> +
> +extern int my_yyinput(char *buf, int max);
> +
> +#undef YY_INPUT
> +#define YY_INPUT(b, r, m) ({r = my_yyinput(b, m);})
> +
> +#define YY_NO_INPUT
> +#define YY_NO_UNPUT
> +
> +#define YY_EXTRA_TYPE struct sqlhist_bison *
> +
> +#define HANDLE_COLUMN do { sb->line_idx += strlen(yytext); } while (0)
> +
> +%}
> +
> +%option caseless
> +
> +field          [a-z_][a-z0-9_\.]*
> +qstring                \"[^\"]*\"
> +hexnum         0x[0-9a-z]+
> +number         [0-9a-z]+

Do you mean a-f ?

Thanks,
Namhyung
