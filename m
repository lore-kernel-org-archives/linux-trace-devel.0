Return-Path: <SRS0=/f37=TO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142F3C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 May 2019 15:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78842084E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 May 2019 15:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEroM6Hy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfENPFb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 May 2019 11:05:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45434 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfENPFb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 May 2019 11:05:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id j1so10449557qkk.12;
        Tue, 14 May 2019 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eKmYcU0qZ8prGVMhQw+n3k1eXR+U2VKtwEpWmO6d6Vc=;
        b=eEroM6HysoF3Sho8Sy8sXFyJ03IOfCUKOhy4Lwf/cXXTfFKWTqQMbgM61+0IYMQuEL
         6le3dU+KwHJ8YZH5SvQW7OxuQQ0gEQWds0Hno+5cKhKfWba4rbiTNCgBBXSMFSv2UylR
         vMigOpL++wObyAXhMDULkHx9Aj5WyAW39Cnmhi4UtCStb/YEjzp47/BSxSn8LR4+vDV0
         +eNVQ4aUKF9MkbOWUIEDYZn62+JbUpVaYdOtkHvEqM+v5cJBKlzDHLEIrzgcWXAQZcF8
         TnCGHmGZMVxbZ8GvxAGSGl7dvdEqMVJmR+CyDOLpZBCVD7U8BQyEL9XySFy4x5xSuucT
         qxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eKmYcU0qZ8prGVMhQw+n3k1eXR+U2VKtwEpWmO6d6Vc=;
        b=BRSvoiMFSwSVi8M1BfOn7H4UP80Fkat8Q2bN6sWhERUbmgz0af9lN6Lv8LPFQWP2yh
         Pc6+5WntueiXlKjwNFINVn08JNHwUVFr0TfEh3yRMQaLxtW7axfxrNBxxop952ff3u+b
         r8U75H0oH0WaarRAYUsNWt9xxEqIHsosSbsPMSUzIAjFJLWuCfyYwHEKudO9Qr91Kxkk
         TOfEv7CjJQY+z3rZ2xWvWAxItnXETK8BTaOuepob8wGLWl78ck93Ze//Ci0BkVLM7TPq
         MVSuuqcyoGs7ec3hG7Gl+o9wg4qTcb/IFHeDPE4oySfI2YFMzrOTtnjckHycugIhXWdd
         b2lw==
X-Gm-Message-State: APjAAAVw/o15o1sS9C23MuRpWlpRAGKJXEjmDr4GyjkLayaPhOCTGgdd
        o6I24WZWXWFCpIBuDiPcXwZ1Mv3hFNc=
X-Google-Smtp-Source: APXvYqzb+BJaFqPoNxLpBoJK35c/6OT9AOOeq+7nTYl01Pdh7ItBdn5cJdLSn3xsj1Vf7fnR3zSvQA==
X-Received: by 2002:ae9:df82:: with SMTP id t124mr20525013qkf.170.1557846330160;
        Tue, 14 May 2019 08:05:30 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.211.58])
        by smtp.gmail.com with ESMTPSA id m18sm8720437qki.21.2019.05.14.08.05.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 08:05:29 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9C41D403AD; Tue, 14 May 2019 12:05:24 -0300 (-03)
Date:   Tue, 14 May 2019 12:05:24 -0300
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/27] tools lib traceevent: Remove hard coded install
 paths from pkg-config file
Message-ID: <20190514150524.GA1756@kernel.org>
References: <20190510195606.537643615@goodmis.org>
 <20190510200105.966709757@goodmis.org>
 <20190510161150.20be7f1e@gandalf.local.home>
 <BDB00110-43B1-4766-BB21-D7BF6FDD5EC7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BDB00110-43B1-4766-BB21-D7BF6FDD5EC7@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Fri, May 10, 2019 at 05:25:10PM -0400, Arnaldo Carvalho de Melo escreveu:
> On May 10, 2019 4:11:50 PM AST, Steven Rostedt <rostedt@goodmis.org> wrote:
> >On Fri, 10 May 2019 15:56:07 -0400
> >Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >> 
> >> Install directories of header and library files are hard coded in
> >> pkg-config template file.
> >> 
> >> They must be configurable, the Makefile should set them on the
> >> compilation / install stage.
> >> 
> >> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >> Cc: Jiri Olsa <jolsa@redhat.com>
> >> Link:
> >http://lkml.kernel.org/r/20190418211556.5a12adc3@oasis.local.home
> >> Link:
> >http://lkml.kernel.org/r/20190329144546.5819-1-tstoyanov@vmware.com
> >> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> >> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> >Bah!
> >
> >I based my patch series off of the wrong commit, and ended up including
> >this one in this series.
> >
> >Arnaldo,
> >
> >I believe you already applied patch 1 (otherwise I would not have your
> >SOB on it), please ignore. But patch 2 on are new to be applied.
> 
> 
> Ok, I'll be back at work early next week and will peixes this,

Done.

- Arnaldo
