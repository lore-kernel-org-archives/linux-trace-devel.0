Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfADV2n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 16:28:43 -0500
Date: Fri, 4 Jan 2019 16:28:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark-qt: Rearrange the "Filter" top menu
Message-ID: <20190104162840.3275a530@gandalf.local.home>
In-Reply-To: <20190104162508.1207a9e1@gandalf.local.home>
References: <20190104195726.24264-1-ykaradzhov@vmware.com>
        <20190104162508.1207a9e1@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 4 Jan 2019 16:25:08 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> >  kernel-shark-qt/src/KsMainWindow.cpp | 42 ++++++++++++++++++++++++++--
> >  kernel-shark-qt/src/KsMainWindow.hpp |  4 +++
> >  2 files changed, 44 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsMainWindow.cpp
> > index a375126..3eb3692 100644
> > --- a/kernel-shark-qt/src/KsMainWindow.cpp
> > +++ b/kernel-shark-qt/src/KsMainWindow.cpp
> > @@ -54,6 +54,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
> >    _showEventsAction("Show events", this),
> >    _showTasksAction("Show tasks", this),
> >    _hideTasksAction("Hide tasks", this),
> > +  _showCPUsAction("Show CPUs", this),
> >    _hideCPUsAction("Hide CPUs", this),
> >    _advanceFilterAction("Advance Filtering", this),
> >    _clearAllFilters("Clear all filters", this),
> > @@ -208,6 +209,9 @@ void KsMainWindow::_createActions()
> >  	connect(&_hideTasksAction,	&QAction::triggered,
> >  		this,			&KsMainWindow::_hideTasks);
> >  
> > +	connect(&_showCPUsAction,	&QAction::triggered,
> > +		this,			&KsMainWindow::_showCPUs);
> > +

We don't need to comment out the unused hideCPU/TasksAction, but we
could add a comment that says that they are currently unused.

> >  	connect(&_hideCPUsAction,	&QAction::triggered,
> >  		this,			&KsMainWindow::_hideCPUs);
> >  
> > @@ -322,8 +326,9 @@ void KsMainWindow::_createMenus()
> >  
> >  	filter->addAction(&_showEventsAction);
> >  	filter->addAction(&_showTasksAction);
> > -	filter->addAction(&_hideTasksAction);
> > -	filter->addAction(&_hideCPUsAction);
> > +// 	filter->addAction(&_hideTasksAction);
> > +	filter->addAction(&_showCPUsAction);
> > +// 	filter->addAction(&_hideCPUsAction);

Commenting out code is messy. But adding comments about why functions
are unused is fine.

-- Steve

> >  	filter->addAction(&_advanceFilterAction);
> >  	filter->addAction(&_clearAllFilters);
> >  
> > @@ -621,6 +626,39 @@ void KsMainWindow::_hideTasks()
> >  	dialog->show();
> >  }
> >  
> > +void KsMainWindow::_showCPUs()
> > +{
> > +	kshark_context *kshark_ctx(nullptr);
> > +	KsCheckBoxWidget *cpu_cbd;
> > +	KsCheckBoxDialog *dialog;
> > +
> > +	if (!kshark_instance(&kshark_ctx))
> > +		return;
> > +
> > +	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
> > +	dialog = new KsCheckBoxDialog(cpu_cbd, this);
> > +
> > +	if (!kshark_ctx->show_cpu_filter ||
> > +	    !kshark_ctx->show_cpu_filter->count) {
> > +		cpu_cbd->setDefault(true);
> > +	} else {
> > +		int nCPUs = tep_get_cpus(_data.tep());
> > +		QVector<bool> v(nCPUs, false);
> > +
> > +		for (int i = 0; i < nCPUs; ++i) {
> > +			if (tracecmd_filter_id_find(kshark_ctx->show_cpu_filter, i))
> > +				v[i] = true;
> > +		}
> > +
> > +		cpu_cbd->set(v);
> > +	}
> > +
> > +	connect(dialog,		&KsCheckBoxDialog::apply,
> > +		&_data,		&KsDataStore::applyPosCPUFilter);
> > +
> > +	dialog->show();
> > +}
> > +
> >  void KsMainWindow::_hideCPUs()
> >  {
> >  	kshark_context *kshark_ctx(nullptr);
> > diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsMainWindow.hpp
> > index 301acc9..c29829a 100644
> > --- a/kernel-shark-qt/src/KsMainWindow.hpp
> > +++ b/kernel-shark-qt/src/KsMainWindow.hpp
> > @@ -120,6 +120,8 @@ private:
> >  
> >  	QAction		_hideTasksAction;
> >  
> > +	QAction		_showCPUsAction;
> > +
> >  	QAction		_hideCPUsAction;
> >  
> >  	QAction		_advanceFilterAction;
> > @@ -173,6 +175,8 @@ private:
> >  
> >  	void _hideTasks();
> >  
> > +	void _showCPUs();
> > +
> >  	void _hideCPUs();
> >  
> >  	void _advancedFiltering();  
> 
