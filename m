Return-Path: <SRS0=5emk=3Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DCCC3524A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Feb 2020 04:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BE12086A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Feb 2020 04:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IyapnXT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgBDEmH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 23:42:07 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36631 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgBDEmH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 23:42:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so1888522wma.1;
        Mon, 03 Feb 2020 20:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=khtrtOCVWWeJbPnRhjdZ9vo6WVczqxHC+cLqbAHzhTM=;
        b=IyapnXT25ffCnYZBCGvwwVauH0FM4omVPnwZ74gJZfHIDS8aFvE9xoUaL3zyGvKM/z
         m75q2TvrUCXJbvTkoXJLlP5KgCYiH4fLXas+HD9dhWBCQmNC7c3VWtUwCXL8werx/yTI
         /7GjYvPbK9+U2WwOfF9yA4zIKGtqXUosyn/OGI4hATzvzq51T+jsl65fRORq9564Wfxr
         CTt0EfV+WdZcmY+gyuy30GcMZQS5eNjNCnDJ5T4xpJh8izruvSMOsGrIHwUkVBbndxoo
         VAfUmyQ6G1mP+feAKQhDOmBM4w+KP82GZcy6X0Jhcf4ZXAChF+TQwPwHqw49pc5sACaJ
         sdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=khtrtOCVWWeJbPnRhjdZ9vo6WVczqxHC+cLqbAHzhTM=;
        b=LeDsWu4oDimniD8aH+jEzFopB9Wmq26NMx/vPKOBPhi77ilZYbs3+dvXOKcuAxGnJ3
         NOJyXLjfzjAOT8BVz4UIDyNxaeuTnhHqzDwhYvEAFY2L+HVZ04Q32SFLI3fQJo9kjk44
         l6r1Gp852BwGx3ffJ/Sbo7J9MXwPPfHnPNV+zgLyPC6av/1w407lZrZbi6v0h+78daeI
         JkEXPcXp26VgEN77xjUK7MQb5BHxoBs9fWUA2tuF8fzoSNJNBdGqKIwBWzirUxRa7FIq
         gjCThiWMA7ScVN4LtNxixHwIpaE2fUsbfEKeIW0GOkAEq4FdtVu9zE6JSlJMO8hmTnjy
         9k4g==
X-Gm-Message-State: APjAAAXAQffmgbRL0yQa6AsegLDX2sXToCBBOCRf3ZFyiTz5xSea0q7f
        7EQ5oBLSedn85OJ/GSGuUOqEXohc
X-Google-Smtp-Source: APXvYqwg2guMhUMIeFkhjCYK/XOBEUN9P6WzktGJBbYo1Uo2tsf2GCh5kRud4Khc4H2mfDoORG01pQ==
X-Received: by 2002:a1c:8156:: with SMTP id c83mr2959034wmd.164.1580791323469;
        Mon, 03 Feb 2020 20:42:03 -0800 (PST)
Received: from felia ([2001:16b8:2daa:dc00:2c0a:8928:125e:2b0f])
        by smtp.gmail.com with ESMTPSA id f207sm2179773wme.9.2020.02.03.20.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 20:42:02 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Tue, 4 Feb 2020 05:41:56 +0100 (CET)
X-X-Sender: lukas@felia
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] MAINTAINERS: add TRACE EVENT LIBRARY section
In-Reply-To: <CAHp75VezYub1YzGSMrwQ7ntAV6EftgLxFiQu9wVnekPHPe4d_g@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2002040533360.3062@felia>
References: <20200201161931.29665-1-lukas.bulwahn@gmail.com> <CAHp75VezYub1YzGSMrwQ7ntAV6EftgLxFiQu9wVnekPHPe4d_g@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Mon, 3 Feb 2020, Andy Shevchenko wrote:

> On Sat, Feb 1, 2020 at 6:21 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> >
> > The git history shows that the files under ./tools/lib/traceevent/ are
> > being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
> > and are discussed on the linux-trace-devel list.
> >
> > Add a suitable section in MAINTAINERS for patches to reach them.
> >
> > This was identified with a small script that finds all files only
> > belonging to "THE REST" according to the current MAINTAINERS file, and I
> > acted upon its output.
> 
> > +TRACE EVENT LIBRARY
> > +M:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> > +M:     Steven Rostedt <rostedt@goodmis.org>
> > +L:     linux-trace-devel@vger.kernel.org
> > +S:     Maintained
> > +F:     tools/lib/traceevent/
> 
> Don't forget to run early mentioned scripts (in some other threads).
>

Andy, I did run on next-20200203:

$ ./scripts/checkpatch.pl -f MAINTAINERS

WARNING: MAINTAINERS entries use one tab after TYPE:
#14607: FILE: MAINTAINERS:14607:
+M:     Micah Morton <mortonm@chromium.org>

WARNING: MAINTAINERS entries use one tab after TYPE:
#14608: FILE: MAINTAINERS:14608:
+S:     Supported

WARNING: MAINTAINERS entries use one tab after TYPE:
#14609: FILE: MAINTAINERS:14609:
+F:     security/safesetid/

WARNING: MAINTAINERS entries use one tab after TYPE:
#14610: FILE: MAINTAINERS:14610:
+F:     Documentation/admin-guide/LSM/SafeSetID.rst

total: 0 errors, 4 warnings, 18577 lines checked


That issue in MAINTAINERS has a pending patch since 2019-12-07, with three 
attempts of asking to be picked up by now:

- https://lore.kernel.org/lkml/20191207182751.14249-1-lukas.bulwahn@gmail.com/
- https://lore.kernel.org/lkml/20200116185844.11201-1-lukas.bulwahn@gmail.com/
- https://lore.kernel.org/lkml/20200204040434.7173-1-lukas.bulwahn@gmail.com/

It is not related to this patch in MAINTAINERS here.


I also ran $ perl ./scripts/parse-maintainers.pl and checked the generated 
diff for this entry, but there was no reordering required; a one-element 
list of F: entries is difficult to get unsorted ;)

I am not adding any mess (ordering issues) to MAINTAINERS with this patch, 
other than what is already there, but cleaning that up is completely other 
story.

Lukas
