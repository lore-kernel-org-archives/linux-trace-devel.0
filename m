Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbeLNOwq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 09:52:46 -0500
Date: Fri, 14 Dec 2018 09:52:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] kernel-shark-qt: Lock completely the searching
 panel when searching
Message-ID: <20181214095244.444f4819@gandalf.local.home>
In-Reply-To: <20181214095037.05d37f87@gandalf.local.home>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
        <20181214125212.9637-2-ykaradzhov@vmware.com>
        <20181214095037.05d37f87@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 09:50:37 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 14 Dec 2018 12:52:34 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
> > So far, when searching we lock only the text field of the  searching
> > panel. This may create a deadlock (as reported by Steven) in the case

BTW, we should probably use the normal way of documenting "reported
by", which would be (see below).

> > when the user presses "Next" or "Prev." button in the same time when
> > a parallelized search is in progress. This patch aims to protect
> > against such a deadlock by locking all components of the panel, except
> > the "Stop search" button.
> > The text panel gets locked only during the actual searching.
> > 

Reporte-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

> > Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> > ---
> >  kernel-shark-qt/src/KsTraceViewer.cpp | 27 +++++++++++++++++++--------
> >  kernel-shark-qt/src/KsTraceViewer.hpp |  2 ++
> >  2 files changed, 21 insertions(+), 8 deletions(-)
> > 


> Can we add two helper functions and use that instead?
> 
> void KsTraceViewer::_searchPanelLock(void)
> {
> 	_lockSearchPanel(true);
> }
> 
> void KsTraceViewer::_searchPanelUnlock(void)
> {
> 	_lockSearchPanel(false);
> }
> 
> This its more in line with the lock / unlock paradigm than passing in
> true and false.
> 

I may apply this series anyway, and we could just add the helper
functions in a separate patch.

-- Steve
