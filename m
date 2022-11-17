Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5411C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Nov 2022 22:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbiKQWwi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbiKQWwV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Nov 2022 17:52:21 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856F865E53
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Nov 2022 14:52:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p16so2415700wmc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Nov 2022 14:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wt8mo/vmbZwNG8GL/TKOQ4X0XW2Ob2p8e2KGFxJx1qo=;
        b=S81v9zXCrlVa1P7JdBW/JpWc4PV1I/azzGigr+dVNTPAvkNJSd66X2QQ4AsI0Jvesb
         BYu6xt9q+UIyPvvli2lQEImOd5npZYrtQzAA0tUzUTIPhuADa1svox4+UaWvWqvgx5+t
         ieDx11JNpPMr9OgXPQccUR8OazG0Qmhd13bzqwJuzTmwoeJiiGQ6BNnIH0qmn/R7IrGV
         OdQVhTNA5vTqoaTP1P7W+5EqyWsJ6k866/hxaCYaM09p9e8VTdIuhncN579tXoDGsqz2
         ujwMrksk8nxB+dAFINDJhS0onaCXT3E62y/QAlxGzFsube6XYTVtJScTjdKJrc3SXay6
         7i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wt8mo/vmbZwNG8GL/TKOQ4X0XW2Ob2p8e2KGFxJx1qo=;
        b=ZIWzP/5cvQEW6bueyi15sNv3QLVF9YL7rZfaM2GlWAmTCGSFGIrs2LQfASwn7g03ko
         fkGe743aQUxUixo7hsG6Wxkl37bFLq+v5BG1wrC0vNiyHESdhQ4SXECwngBpHgPzX7y0
         +b47NqJEgW8nwc97NaR6f255420j3Oby2bZiT/Yns1IcyuXyOlQkPe0Re8nf6NjWc/aO
         4ZsvjhwxY1Gj4tk5jPoGyjMlC6/TxM5kbX3z7Gfdp7Nv8E2ZJ5yFRJUVJPww91ULT8V4
         amRRZpW9w+KKHRymMOqadL+uumIhJ30RKpK6lFm6QTUvrDpIhsXI5nRWK9s39W89RWkC
         MGLQ==
X-Gm-Message-State: ANoB5pn9yEZxd+dRKnfHs3fbytMjCgXNtdbqxCEVMBH3txXKg/cBQlqf
        jpye57ctB6rgM98CbEnrD7pgNdmoKO3znoVveXuP/g==
X-Google-Smtp-Source: AA0mqf7I7gZKcrogPJVyhv0VubDrk/oH7agbpOC6L9wKsryHGMj4QrtQY59KLOsHOGRRapuVENIWQjQ01+0QCtrGqTA=
X-Received: by 2002:a05:600c:4920:b0:3cf:8b23:549c with SMTP id
 f32-20020a05600c492000b003cf8b23549cmr2947166wmp.174.1668725538850; Thu, 17
 Nov 2022 14:52:18 -0800 (PST)
MIME-Version: 1.0
References: <CAP-5=fWxAjEia-Qbm0RVzKOxyiod8rUOBieqaGK=DtQboDe3Qw@mail.gmail.com>
 <20221117134250.532a44c9@gandalf.local.home>
In-Reply-To: <20221117134250.532a44c9@gandalf.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 17 Nov 2022 14:52:06 -0800
Message-ID: <CAP-5=fUmWPz8ZyfuXu929VZkRNXKmD0PCX9WwZNWu+17-ENKiw@mail.gmail.com>
Subject: Re: Remove traceevent from tools/lib
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 17, 2022 at 10:42 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 17 Nov 2022 09:59:46 -0800
> Ian Rogers <irogers@google.com> wrote:
>
> > Means that perf is cleanly(ish) separated from libraries in tools/lib.
> > traceevent in tools/lib is out of date (~2years - version 1.1.0 whilst
> > the latest is 1.6.3 [1]) . Should we delete traceevent from tools/lib
>
> Yes please!
>
> Strongly-acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

I sent v1 patches:
https://lore.kernel.org/lkml/20221117224952.358639-1-irogers@google.com/

Thanks,
Ian

> -- Steve
>
> > and just make LIBTRACEEVENT_DYNAMIC the only supported perf build
> > option? I guess this may break old distributions that may not have
> > libtraceevent, but even so I'm not sure that should motivate not
> > cleaning this up (if they are building perf they can build
> > libtraceevent).
>
