Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbfAJObL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 09:31:11 -0500
Date: Thu, 10 Jan 2019 09:31:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] Cosmetic modifications in KsQuickContextMenu
Message-ID: <20190110093108.61c3fce5@gandalf.local.home>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 10 Jan 2019 15:44:14 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> All modifications to the KsQuickContextMenu done in this series of
> patches have been sent already, but as a single patch ([PATCH v2 2/6])
> The original patch was divided in order to provide a clean sequence of
> distinct changes.
> 
> Yordan Karadzhov (5):
>   kernel-shark-qt: Remove _deselectAction from KsQuickContextMenu
>   kernel-shark-qt: Remove the "Apply to" checkboxes from
>     KsQuickContextMenu
>   kernel-shark-qt: Rearrange the KsQuickContextMenu menu
>   kernel-shark-qt: Add "clear all filters" action to KsQuickContextMenu
>   kernel-shark-qt: Add section separator in KsQuickContextMenu
> 
>  kernel-shark-qt/src/KsQuickContextMenu.cpp | 63 +++++++---------------
>  kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
>  2 files changed, 23 insertions(+), 44 deletions(-)
> 

Applied. Thanks a lot Yordan!

-- Steve
