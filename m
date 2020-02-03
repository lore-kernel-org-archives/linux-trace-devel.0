Return-Path: <SRS0=XOGr=3X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D7BC35247
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Feb 2020 10:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A8920721
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Feb 2020 10:23:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vfkTNXzf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgBCKXy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 05:23:54 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39668 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgBCKXx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 05:23:53 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so5678177plp.6;
        Mon, 03 Feb 2020 02:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ygzMeYDHdIu6FabSbP67HIaiz5b6P4CRnJ4Hak7tsY=;
        b=vfkTNXzfHRMeFNDUTLiFgrVuVeQ16cr3W1p+2Ln6+DxbN3Sp58Ed0gLrLasqtPD5iv
         asTGdlS7dJ8qJBhBofLYSDHS4fKz6TUqUm/KZwmTbQ2mARDQ3w0NbVXJzNvA2fM+yAdg
         FlPrCxaUT2frwpgiwkV39+4jf0kM1dqAkhAygSGe/X0LYNrjag2E0clZK2IaQOhgwwWi
         K0a1Y2U1pyw2DLyp1RPYUMO+63e4kdUuJiSvGkvFsprT+tglsMDwfSpyr5exdDztsHWj
         fg3hLupdCiI8Rs/+E4CnkrmxNjEX1jXJy4M55b5WPBZ6l5KRtYt/Zjr8Is1VjOoiaiFD
         xzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ygzMeYDHdIu6FabSbP67HIaiz5b6P4CRnJ4Hak7tsY=;
        b=lncX33h4uAxMJT0m6cMrejFkp194Ucj68C8JE+rWyByBcGCemk0K51YchRGIJcVe60
         I+vEjR7faOCHcvvE4SNA/EcLu1OLWlJjgcREn7VZgBlAyKlw6dw+VqqxUQasfKjSgCEZ
         kXteq2Y8U+HBlOElelyDFSRoOec5EMK9JkHJieqAaR8DsR7+FCJzeHrrzq9xBxK4h1wG
         33hwvqDjgDpEfrJXrNWw0I+JP1/nms+0Ejkkn0tSrECyOsdoVAP6id29uPyq9GpHla7K
         Tf9vYocy30pHy+Sy/EwysmzXPzA1Vb2/mFY8aXVlQF9YUriOAdwv3LWuzdRVi1B11ZcK
         UdKQ==
X-Gm-Message-State: APjAAAXHl7DZ/P9lO/pQsvgDWtDWUE60hfj8uNm5PIJqFRyoh/oaa04l
        QhI58m7BYzApzM8nY0qercpuEsSTbsijOyZ9Rzc=
X-Google-Smtp-Source: APXvYqwYKUBVPWsmExO5T7OGN6sQqSkBbqMJaj83l8H+dStpIIxoMm17XbeeKY72nzLes4kuNlne4jE7RRqB4nit6YA=
X-Received: by 2002:a17:902:b598:: with SMTP id a24mr22398587pls.262.1580725432990;
 Mon, 03 Feb 2020 02:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 3 Feb 2020 12:23:44 +0200
Message-ID: <CAHp75VezYub1YzGSMrwQ7ntAV6EftgLxFiQu9wVnekPHPe4d_g@mail.gmail.com>
Subject: Re: [PATCH RFC] MAINTAINERS: add TRACE EVENT LIBRARY section
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Feb 1, 2020 at 6:21 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> The git history shows that the files under ./tools/lib/traceevent/ are
> being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
> and are discussed on the linux-trace-devel list.
>
> Add a suitable section in MAINTAINERS for patches to reach them.
>
> This was identified with a small script that finds all files only
> belonging to "THE REST" according to the current MAINTAINERS file, and I
> acted upon its output.

> +TRACE EVENT LIBRARY
> +M:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> +M:     Steven Rostedt <rostedt@goodmis.org>
> +L:     linux-trace-devel@vger.kernel.org
> +S:     Maintained
> +F:     tools/lib/traceevent/

Don't forget to run early mentioned scripts (in some other threads).

-- 
With Best Regards,
Andy Shevchenko
