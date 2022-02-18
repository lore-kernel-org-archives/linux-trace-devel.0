Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE12FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 21:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbiBRVrX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 16:47:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiBRVrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 16:47:23 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C454FB6
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 13:47:05 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id d3so5672456ilr.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 13:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D4EHHWyfoT/rr/zF/3XkhN6TZa+Q2+s7f/3TX+/eAIE=;
        b=uX0jIVgD/IZXBZ1D0XWEHkhiFXqVEqUbmvXqzCu7D6G9RkPXqG3fHvMWxlJ0jmIqHN
         7lSQ8Mp37jKMGktwSPjo+nQJseOwEx67X47R4sJb2aJABX/colI/w9uovRvZ29mEKcOp
         XhEk+UuB4isdg4TVknqD4zWySb8V5XtCeNYrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D4EHHWyfoT/rr/zF/3XkhN6TZa+Q2+s7f/3TX+/eAIE=;
        b=5AtDyIADnOsLBABLvUBrFAgscyIec0pnzRgvBUM3AGoJYScnjcJHWM7uBQgk9oSPdk
         BUJDyLMokzPEIygFp90vI9iOfX/FhgXnWhyozNvtCqm44vTnnSir9G5sQjHoEMG1nCCz
         v1hnCdkXnqsPHt+2gjy7l0T0r/JeQBUemOhDc8JragUJCyGcGHjQcqocZrCSp1zhWjie
         Fi7Svo4ZOi5FbH8B/UMe53ajAlBQPrwxs1UJdfBkTS0xVQTYAzdE8f3WBJ/XGqd9z0Qr
         Hiq0jC4HmM9S9hc1FAoNqCUYp+ZZPhz8gDq+kQHhot9D3uKMTfw06KTlPfVnNZLfFNwu
         TZcg==
X-Gm-Message-State: AOAM531w7TOzRqA37n1tYe8qs5zbJHI6GzF2cfPEuCQNiGn3jHUHacG/
        Vtt7nrzFR/aznJdPXVsnnkyMrfe7MwDsSe0FmCyGALZ6hpU=
X-Google-Smtp-Source: ABdhPJyTbMJZTQBzeZmKmRYQ3yRp+vy5cpqMvrR1NRMx3jJvr/sjHIfLJrwlBgBRme3sK+japIzzH2zp1j8mRHo5x4Q=
X-Received: by 2002:a05:6e02:12c6:b0:2bc:7a49:cf26 with SMTP id
 i6-20020a056e0212c600b002bc7a49cf26mr6842674ilm.286.1645220824947; Fri, 18
 Feb 2022 13:47:04 -0800 (PST)
MIME-Version: 1.0
References: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
 <20220218142216.535d56c6@gandalf.local.home> <20220218142829.166ce9f6@gandalf.local.home>
In-Reply-To: <20220218142829.166ce9f6@gandalf.local.home>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 18 Feb 2022 16:46:54 -0500
Message-ID: <CAEXW_YTt7OkZYeYRQCvMq4+3_TUP3ZBRe8FKn4q6RNAkmme5_w@mail.gmail.com>
Subject: Re: Rotation of instance traces
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 18, 2022 at 2:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 18 Feb 2022 14:22:16 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Now to be able to do things like splice, and zero copy from the ring
> > buffer, when you read the ring buffer it swaps out a sub buffer from the
> > writable portion of the ring buffer and makes it into the "reader_page".
> > The reader page is now own by the reader, and will never be written to.
>
> I need to correct that statement about never being written to. It can be.
> If the current write head is on the page as it gets swapped out and becomes
> the reader page. A new write will happen on the reader page, but once the
> writer walks off the reader page and into the main ring buffer, it will
> never touch the reader page again.
>
> The read logic detects this, and will do copies of the page to send it to
> the user as it can not give the page itself to the user with the writer
> still on it.

Thanks Steve! I went over your email and it makes sense. I also cannot
reproduce this issue any more so I don't know what I did :P.  I was
messing with the buffer_size_kb while doing reads from 'trace', so
maybe I managed to get the read page in a weird state? Anyway, I think
I am going to collect these traces only with 'trace_pipe_raw' , so as
long as the data in the ring buffer is consistent, that's good.

I was mostly concerned about the validity/integrity of the data stored
since the 'trace' made it look like a corruption :P , when I was doing
"head -n 40 trace" , I was seeing the timestamps of the first couple
of records updating, but the data remained the same. Almost as if, the
header of the record was changing but not the payload. I am not sure
if you have seen anything like that.

Thanks,
             Joel
