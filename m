Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47BBC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABCBD2082C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKJDz3Kf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfFLPWi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:22:38 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34714 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfFLPWh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 11:22:37 -0400
Received: by mail-ot1-f65.google.com with SMTP id n5so459693otk.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jun 2019 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tcvQz3H1fN/MAPWBQO4HMRMLBqpUzsmUIbvM8As6YA4=;
        b=QKJDz3KfafCwE5/2FuKrOJqDjDKo6j2svM+ht1VDhhVj73hX+1hx2AehSSxbCQauk9
         x5JPvI4toDzYjsBBM5cEz+8uTiU2KtoAtUsC1xEBJaraSWL50P+MG1CjJNSSzoYQ8XXS
         vtL7vqJ3vr1gsWqVTMiLV9ph3xhv16gAUi5Hsqlcfn7eksNky89fFH9y+TW3DQJfbdoa
         0kBLiLwUwglawrP62SA5wgfzZ0xWOjkyxBW8KCinIQh0VdnbqoEw92B/hNcwqaRT3ion
         1R+Hy5GN9g1MMfmYHBJBlD8gbK0SV/PiTb8LflQtwhnk6LdW+26K4N/O25euV6eJdnGs
         Sq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tcvQz3H1fN/MAPWBQO4HMRMLBqpUzsmUIbvM8As6YA4=;
        b=j9ItdiBgwgQoGfrYNzzPkZKNj2lp174Dp5peQubAmMfecbqg0WF/n8YtNie3Q6JkRy
         08eCBRsJpU0JtzJOaHTTMRFQFwilbTaOhKj/TKLOv6CnWU62nAanamaBJ9NQxue7JrE+
         RnSSc/9pThLFhLHbDlFpSxCgta2F/JtiJMI0JHUkPnvSOCaGSGeABsU1/6//D6D5z7pl
         NtafJVlz/YlNPBgCzdECrFPPTQz7GmQ+yaK4VOpXrSfyoGZcHDYfDM7wBAloiFP9mSwi
         c1dMrECi8hLI/ANch0aYrKr+vucrLlT+Tb/0CJHFZD0SZtxH591973pH1k6pvRLpP9Bz
         Al7g==
X-Gm-Message-State: APjAAAUy8/6awOVr1ts/HoC7Dqewm0ArmhoQ2GqAspvs0pWMNJE2AFkv
        yqEHu6wH8E804TR7cUM/MNSqqSywptzr6gCXv0s=
X-Google-Smtp-Source: APXvYqzWw/KbJaC7AoqUjaJFcQUUa03VOxRBzCK3ZobPfk3TSdBoT1jTWzgHGySxM8VH/LB70jUR8VQ3c9h0vrpzxgk=
X-Received: by 2002:a9d:6a19:: with SMTP id g25mr36182697otn.77.1560352955994;
 Wed, 12 Jun 2019 08:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190612035902.16366-1-amikhak@wirelessfabric.com> <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
In-Reply-To: <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
From:   Alan Mikhak <alanmikhak@gmail.com>
Date:   Wed, 12 Jun 2019 08:22:22 -0700
Message-ID: <CAOY98NeuPDgnpiHZqepa1gBuSjaDuyOgySccBeuRwLj4XdVe+g@mail.gmail.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 12:34 AM Yordan Karadzhov <ykaradzhov@vmware.com> w=
rote:
> On 12.06.19 =D0=B3. 6:59 =D1=87., Alan Mikhak wrote:
> > Fix compiler error at KsSession.cpp:457:30 on Raspberry Pi 3
::
> I am really curious to know how does KernelShark look and feel on
> Raspberry Pi. Would you shared with us your impressions.
> Honestly, I will be surprised if everything works fine ;)
>

Hi Yordan,

KernelShark launches on my Raspberry Pi 3 model B+, loads my trace
file, renders the screen elements, and is responsive. I have enabled a
swap file and GPU acceleration with extra memory for the GPU. From
looking at the code, rendering may even work on the CPU without
acceleration, but haven't tried it.

The abort issue on libkshark-model.c:242 currently limits KernelShark
on my Raspberry Pi 3 model B+:
https://bugzilla.kernel.org/show_bug.cgi?id=3D203869

Regards,
Alan
