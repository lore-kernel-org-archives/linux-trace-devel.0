Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E1BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 09:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58CB21872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 09:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MI+wsPOs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfCOJuB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:50:01 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38719 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbfCOJuB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 05:50:01 -0400
Received: by mail-it1-f196.google.com with SMTP id k193so9847203ita.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 02:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mzJddyqi7LC9gzwYvzr2jC4WZlEue0/LlQ0dwxXozOg=;
        b=MI+wsPOs9AEzfwb8iD06jHirJw8xsWHTsxZrQ5MIFCw77uWRl3Ad35fZZBZ9a94YWm
         h3eg6PkaBQRy264Fw1p2zbu72TpDEteVeBGjmK6mWeDj+uNt0frwOln8KGWfoL6XK7Oi
         tBSuqV4eACNYBGMj0D65B+gPkAkWUBDPq9kCZ2/IV0GYMWfr8woPSAtJS2r5IVCJkuK6
         ij5o4SZdpfoKLHs62tTCiuQnNBPPvb/UXU2xbdHwv+wr+MIATNo2Plo/C6Q8clyYnnW1
         NnXYGE3SL+wLrDGGdGoOmGppRiwgsXNoJVBCxhjegu9iD4SpEn20Co/BoSbzyFGgax0L
         ey4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mzJddyqi7LC9gzwYvzr2jC4WZlEue0/LlQ0dwxXozOg=;
        b=G+7AIoOE1khEEqBupZYF0QydoNRde/5w1LT7NkaeHh6XhWjiY0cppiBGSTK6blyxw0
         ar+yTcbH4pJw5CRRjREsMO7g3LrRv5jKsJqQiRn+d34IAPPNvHU0clh+M8erOzE7gKQu
         F4oRXI051ARi/98QIuQ6Rs8oOB+/gLYlDKVkZPH3UDRwia3Q8ySv9ygB8UUmSrH3NTBk
         4rfw4IXJEStTPftaUGa0dJFxVzukenQFPF+EdbqC4OlKuykwo5AOTYZcWRFNqZagUYdU
         1EcNos7QkpS6kgv5EZQRA4RVhvWvYed3M+RC41aQZ5LQqp9Zn7esc9pVZouwgpAvJfxE
         VGLA==
X-Gm-Message-State: APjAAAUeN584FVxJVtxKm/O+LzO8vXV6Riu/7NWFWkS2Q+8BtaTWGj5x
        kGWmSJl5gP2w7IcH133YSbqG4i3o+WopU3jiGA==
X-Google-Smtp-Source: APXvYqzjiXjdU11lICEDBBg6ghblNaSpVw9rdJaZdW18Td6pMEclzodIDd6cEu+ba1fwGKoD4UbUXDSBvGXjQ/BquZs=
X-Received: by 2002:a02:8a4a:: with SMTP id e10mr1918376jal.120.1552643400221;
 Fri, 15 Mar 2019 02:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190313150717.21345-1-ykaradzhov@vmware.com> <20190313150717.21345-4-ykaradzhov@vmware.com>
In-Reply-To: <20190313150717.21345-4-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 15 Mar 2019 11:49:48 +0200
Message-ID: <CAE0o1NviJAsP8Nk8YhPXPfYkCKGrZ=rYntv8fX7WchC-LH4JcQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] kernel-shark: Rename the manu action for managing
 registered plugins
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 5:08 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> The menu action in Tools that is used to manage all registered
> plugins is renamed in order to avoid confusion with the "Add plugins"
> menu action, implemented in the previous patch.
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsMainWindow.cpp | 10 +++++-----
>  kernel-shark/src/KsMainWindow.hpp |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 6428d4d..f165797 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -58,7 +58,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>    _clearAllFilters("Clear all filters", this),
>    _cpuSelectAction("CPUs", this),
>    _taskSelectAction("Tasks", this),
> -  _pluginsAction("Plugins", this),
> +  _managePluginsAction("Manage plugins", this),
>    _addPluginsAction("Add plugins", this),
>    _captureAction("Record", this),
>    _colorAction(this),
> @@ -228,10 +228,10 @@ void KsMainWindow::_createActions()
>                 this,                   &KsMainWindow::_taskSelect);
>
>         /* Tools menu */
> -       _pluginsAction.setShortcut(tr("Ctrl+P"));
> -       _pluginsAction.setStatusTip("Manage plugins");
> +       _managePluginsAction.setShortcut(tr("Ctrl+P"));
> +       _managePluginsAction.setStatusTip("Manage plugins");
>
> -       connect(&_pluginsAction,        &QAction::triggered,
> +       connect(&_managePluginsAction,  &QAction::triggered,
>                 this,                   &KsMainWindow::_pluginSelect);
>
>         _addPluginsAction.setStatusTip("Add plugins");
> @@ -341,7 +341,7 @@ void KsMainWindow::_createMenus()
>
>         /* Tools menu */
>         tools = menuBar()->addMenu("Tools");
> -       tools->addAction(&_pluginsAction);
> +       tools->addAction(&_managePluginsAction);
>         tools->addAction(&_addPluginsAction);
>         tools->addAction(&_captureAction);
>         tools->addSeparator();
> diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
> index 1e6d619..a93382a 100644
> --- a/kernel-shark/src/KsMainWindow.hpp
> +++ b/kernel-shark/src/KsMainWindow.hpp
> @@ -130,7 +130,7 @@ private:
>         QAction         _taskSelectAction;
>
>         // Tools menu.
> -       QAction         _pluginsAction;
> +       QAction         _managePluginsAction;
>
>         QAction         _addPluginsAction;
>
> --
> 2.19.1
>

All 4 patches look good modulo a typo in this patch commit message
(:s/manu/menu/g)

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thanks!

-- 
Slavomir Kaslev
