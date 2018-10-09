Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbeJJADl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 20:03:41 -0400
Date: Tue, 9 Oct 2018 12:45:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH 4/4] kernel-shark-qt: Add widget demo example.
Message-ID: <20181009124548.50883c78@gandalf.local.home>
In-Reply-To: <20181008151629.13973-5-ykaradzhov@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-5-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  8 Oct 2018 18:16:29 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> From: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> This patch introduces a basic example, showing how to use KsUtils and
> KsWidgetsLib.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/examples/CMakeLists.txt |   4 +
>  kernel-shark-qt/examples/widgetdemo.cpp | 159 ++++++++++++++++++++++++
>  2 files changed, 163 insertions(+)
>  create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp
> 
> diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
> index 0c83293..e16216e 100644
> --- a/kernel-shark-qt/examples/CMakeLists.txt
> +++ b/kernel-shark-qt/examples/CMakeLists.txt
> @@ -19,3 +19,7 @@ target_link_libraries(confio   kshark)
>  message(STATUS "dataplot")
>  add_executable(dplot          dataplot.cpp)
>  target_link_libraries(dplot   kshark-plot)
> +
> +message(STATUS "widgetdemo")
> +add_executable(widgetdemo          widgetdemo.cpp)
> +target_link_libraries(widgetdemo   kshark-gui)
> diff --git a/kernel-shark-qt/examples/widgetdemo.cpp b/kernel-shark-qt/examples/widgetdemo.cpp
> new file mode 100644
> index 0000000..c9ce86b
> --- /dev/null
> +++ b/kernel-shark-qt/examples/widgetdemo.cpp
> @@ -0,0 +1,159 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +// C
> +#include <sys/stat.h>
> +#include <getopt.h>
> +#include <unistd.h>
> +
> +// C++
> +#include <iostream>
> +
> +// Qt
> +#include <QtWidgets>
> +
> +// KernelShark
> +#include "KsUtils.hpp"
> +#include "KsWidgetsLib.hpp"
> +
> +#define default_input_file (char*)"trace.dat"
> +
> +static char *input_file = nullptr;
> +
> +using namespace std;
> +
> +void usage(const char *prog)
> +{
> +	cout << "Usage: " << prog << endl
> +	     << "  -h	Display this help message\n"
> +	     << "  -v	Display version and exit\n"
> +	     << "  -i	input_file, default is " << default_input_file << endl
> +	     << "  -p	register plugin, use plugin name, absolute or relative path\n"
> +	     << "  -u	unregister plugin, use plugin name or absolute path\n";

Add a exit here, because when I ran this with -h, it still runs the
code.

-- Steve

> +}
> +
> +struct TaskPrint : public QObject
> +{
> +	tep_handle	*_pevent;
> +
> +	void print(QVector<int> pids)
> +	{
> +		for (auto const &pid: pids)
> +			cout << "task: "
> +			     << tep_data_comm_from_pid(_pevent, pid)
> +			     << "  pid: " << pid << endl;
> +	}
> +};
> +
> +int main(int argc, char **argv)
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	QApplication a(argc, argv);
> +	KsPluginManager plugins;
> +	KsDataStore data;
> +	size_t nRows(0);
> +	int c;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return 1;
> +
> +	while ((c = getopt(argc, argv, "hvi:p:u:")) != -1) {
> +		switch(c) {
> +		case 'v':
> +			printf("kshark-gui %s\n", KS_VERSION_STRING);
> +			return 0;
> +
> +		case 'i':
> +			input_file = optarg;
> +			break;
> +
> +		case 'p':
> +			plugins.registerPlugin(QString(optarg));
> +			break;
> +
> +		case 'u':
> +			plugins.unregisterPlugin(QString(optarg));
> +			break;
> +
> +		case 'h':
> +		default:
> +			usage(argv[0]);
> +			break;
> +		}
> +	}
> +
> +	if (!input_file) {
> +			struct stat st;
> +			if (stat(default_input_file, &st) == 0)
> +				input_file = default_input_file;
> +	}
> +
> +	if (input_file) {
> +		data.loadDataFile(input_file);
> +		nRows = data.size();
> +	} else {
> +		cerr << "No input file is provided.\n";
> +	}
> +
> +	cout << nRows << " entries loaded\n";
> +
> +	auto lamPrintPl = [&] ()
> +	{
> +		kshark_plugin_list *pl;
> +		for (pl = kshark_ctx->plugins; pl; pl = pl->next)
> +			cout << pl->file << endl;
> +	};
> +
> +	cout << "\n\n";
> +	lamPrintPl();
> +	sleep(1);
> +
> +	QVector<bool> registeredPlugins;
> +	QStringList pluginsList;
> +
> +	pluginsList << plugins._ksPluginList
> +		    << plugins._userPluginList;
> +
> +	registeredPlugins << plugins._registeredKsPlugins
> +			  << plugins._registeredUserPlugins;
> +
> +	KsCheckBoxWidget *pluginCBD
> +		= new KsPluginCheckBoxWidget(pluginsList);
> +
> +	pluginCBD->set(registeredPlugins);
> +
> +	KsCheckBoxDialog *dialog1 = new KsCheckBoxDialog(pluginCBD);
> +	QObject::connect(dialog1,	&KsCheckBoxDialog::apply,
> +			&plugins,	&KsPluginManager::updatePlugins);
> +
> +	dialog1->show();
> +	a.exec();
> +
> +	cout << "\n\nYou selected\n";
> +	lamPrintPl();
> +	sleep(1);
> +
> +	if (!nRows)
> +		return 1;
> +
> +	KsCheckBoxWidget *tasks_cbd =
> +		new KsTasksCheckBoxWidget(data.pevent(), true);
> +
> +	tasks_cbd->setDefault(false);
> +
> +	TaskPrint p;
> +	p._pevent = data.pevent();
> +
> +	KsCheckBoxDialog *dialog2 = new KsCheckBoxDialog(tasks_cbd);
> +	QObject::connect(dialog2,	&KsCheckBoxDialog::apply,
> +			 &p,		&TaskPrint::print);
> +
> +	cout << "\n\nYou selected\n";
> +	dialog2->show();
> +	a.exec();
> +
> +	return 0;
> +}
