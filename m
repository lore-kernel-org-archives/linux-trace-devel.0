Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B335C4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 07:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CC260F9C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 07:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhHCH2F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 03:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhHCH2F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 03:28:05 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFC9C06175F;
        Tue,  3 Aug 2021 00:27:53 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id z18so5750297ybg.8;
        Tue, 03 Aug 2021 00:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C0npjgl+HG6crVvxafwBN6vIxikeVgWfSY9pE6rAYAA=;
        b=q1ybkuphZ8XwwP1UWgfZwuXU3QIAycNN3HcwkuYW3bYCNdph0SEdA1be+M1hOLsewD
         oDbLm34QbW3+3N2aA/gecXVShOZpAq37D8475xWlSSqW5BdfM721jMO2e3PdJYJn79VE
         rJcWDcLaUCiN//ZHi+Edp65SYI5bRaB6OkOFBF3Od5RUbBHt5PR5/WZmBtkbl4cVxKhl
         b5Y0lPHHhY4XtC3jqDhRisooemDS9Iw8er1y4YGb1OySAvEAt+f2Uj6w9n892MjwDjdQ
         FfZcnIYfvN/tykfweQ5kiwGqOiyw1pJAfqhSDRMlzyoas1JDpdK/Tgcoh6/AxAi7RIz+
         npNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C0npjgl+HG6crVvxafwBN6vIxikeVgWfSY9pE6rAYAA=;
        b=taf4RFFmPLjNXRxitNlFecTnjbKknDCxEwrOpJuglIWY6X/ct/qcowTQMLOxvRCQmk
         03t+Md3Jqaal3F38dA0NQNo1oB8JNhnVDNG+rSm/gwpZCNyRUbPi5NNqOPjcNapR9X6r
         6eAqBPYIUBmKQZ7Zp/553+T6G6zOHFzHW3fMgGYutkh8NpKlZHntgwkQctWW1/y9s+Xj
         cJ2XKXB9qrFLuXnzQm9AtNJCahnmjGBkbK5Qc1bElxvRencCV2jYxQKq9kloYGupG8jj
         /5Q0PiFOJc+LMYc3wa7zVXWHGd+0hJiPpqJTjhgN4HYVYtD1dXbrGGKNIzPzJ+IEcjVw
         3z1g==
X-Gm-Message-State: AOAM532b8ZOkLABfr0rUHQz/cL889BXm5g3GbjounJvnlWxcOclop7WP
        AKAmzkympUnfFNQWAWKJTqStYDPgw6woah8cSk0=
X-Google-Smtp-Source: ABdhPJzij8OZbRZgZ3RMD6+dyy/1WHOYYmERYbqjs0KqznvBC4+9fFCc5ArDbPP05yg+LkRPp/HON3cAb7YVYZaXEjw=
X-Received: by 2002:a25:f310:: with SMTP id c16mr19079345ybs.464.1627975673074;
 Tue, 03 Aug 2021 00:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210803042347.679499-1-rostedt@goodmis.org> <20210803042347.679499-2-rostedt@goodmis.org>
In-Reply-To: <20210803042347.679499-2-rostedt@goodmis.org>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Tue, 3 Aug 2021 09:27:42 +0200
Message-ID: <CAKXUXMzMW5NeCjxXDQEmC-imrbg3AGR4sg+TOwnj0eFRyLSb4g@mail.gmail.com>
Subject: Re: [PATCH v2 01/21] libtracefs: Added new API tracefs_sql()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Daniel Black <daniel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 3, 2021 at 6:23 AM Steven Rostedt <rostedt@goodmis.org> wrote:
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
>     FROM sched_waking AS start JOIN sched_switch AS end
>     ON start.pid = end.next_pid
>
> Special thanks to:
>
>   Lukas Bulwahn for first introducing the idea at RT Summit on the Summit
>     Spring of 2019.

Thanks, Steven, for putting this idea to life.

I hope that the tracing users appreciate this new declarative
interface using SQL and it makes tracing events easier comprehensible
to a larger community of users.

Lukas
