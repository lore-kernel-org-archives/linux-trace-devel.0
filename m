Return-Path: <SRS0=jVtL=2A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98385C43603
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 17:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D4C2077B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Dec 2019 17:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLJRFB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 12:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfLJRFB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 12:05:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E1C2077B;
        Tue, 10 Dec 2019 17:04:59 +0000 (UTC)
Date:   Tue, 10 Dec 2019 12:04:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20191210120458.38f98bed@gandalf.local.home>
In-Reply-To: <20191203103522.482684-17-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-17-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/1C5FZ/xsX6odsch3Phr0LsT"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--MP_/1C5FZ/xsX6odsch3Phr0LsT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue,  3 Dec 2019 12:35:20 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +struct tracecmd_time_sync {
> +	unsigned int			sync_proto;
> +	int				loop_interval;
> +	sem_t				sem;

Ug, semaphores are a horrible construct. I believe you can do the same
thing here with pthread_cond variables. I attached a small program that
uses pthread_cond and pthread_mutex to do interval times like this.

Note, another thing is, you can just have a global "end" variable that
can be set and checked (as I did in my program here).

-- Steve


> +	char				*clock_str;
> +	struct tracecmd_msg_handle	*msg_handle;
> +	void				*context;
> +};
> +

--MP_/1C5FZ/xsX6odsch3Phr0LsT
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pthread_condwait.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <errno.h>
#include <stdbool.h>
#include <pthread.h>

#define gettid() syscall(__NR_gettid)

static bool end;

static void __vdie(const char *fmt, va_list ap, int err)
{
	int ret = errno;

	if (err && errno)
		perror("bmp-read");
	else
		ret = -1;

	fprintf(stderr, "  ");
	vfprintf(stderr, fmt, ap);

	fprintf(stderr, "\n");
	exit(ret);
}

void pdie(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	__vdie(fmt, ap, 1);
	va_end(ap);
}

#define NR_THREADS 8
static int nr_threads = NR_THREADS;
static pthread_t *threads;

static pthread_barrier_t threads_started;

struct t_info {
	int id;
	int interval;
	pthread_mutex_t lock;
	pthread_cond_t cond;
};

static void *thread_func(void *arg)
{
	struct t_info *t = arg;
	pthread_mutex_t *this_mutex = &t->lock;
	pthread_cond_t *this_cond = &t->cond;
	struct timespec ts;
	int cnt = 0;

	pthread_barrier_wait(&threads_started);

	while (true) {

		pthread_mutex_lock(this_mutex);

		printf("task %d running %d\n", t->id, ++cnt);

		if (end)
			break;

		clock_gettime(CLOCK_REALTIME, &ts);
		ts.tv_sec += t->id + 1;
		pthread_cond_timedwait(this_cond, this_mutex, &ts);
		pthread_mutex_unlock(this_mutex);
	}

	pthread_mutex_unlock(this_mutex);

	printf("Task %d finished\n", t->id);

	return NULL;
}

int main (int argc, char **argv)
{
	struct t_info *infos;
	int ret;
	int i;

	infos = calloc(nr_threads, sizeof(*infos));
	if (!infos)
		pdie("calloc");

	threads = calloc(nr_threads, sizeof(*threads));
	if (!threads)
		pdie("calloc");

	pthread_barrier_init(&threads_started, NULL, nr_threads + 1);

	for (i = 0; i < nr_threads; i++) {
		infos[i].id = i;
		if (pthread_mutex_init(&infos[i].lock, NULL))
			pdie("pthread_mutex_init");
		ret = pthread_create(&threads[i], NULL, thread_func, &infos[i]);
		if (ret < 0)
			pdie("creating thread %d", i);
	}

	pthread_barrier_wait(&threads_started);

	sleep(30);

	end = true;
	for (i = 0; i < nr_threads; i++) {
		pthread_mutex_lock(&infos[i].lock);
		pthread_cond_signal(&infos[i].cond);
		pthread_mutex_unlock(&infos[i].lock);
		pthread_join(threads[i], NULL);
	}

	return 0;
}

--MP_/1C5FZ/xsX6odsch3Phr0LsT--
