Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731053AbfACOcz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Jan 2019 09:32:55 -0500
Date: Thu, 3 Jan 2019 09:32:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: multi-thread read bug
Message-ID: <20190103093253.5c06e604@gandalf.local.home>
In-Reply-To: <e85a0404-85e7-b8f7-2c47-0c90ba42e7e0@gmail.com>
References: <e85a0404-85e7-b8f7-2c47-0c90ba42e7e0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 3 Jan 2019 14:08:37 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Ceco,
> 
> I have a problem when trying to call tracecmd_read_at() from different 
> threads. Although the call of tracecmd_read_at() is protected by a 
> mutex,

I believe I stated before that adding a mutex around that wont help at
all.

> I am still getting a segmentation fault.
> A simple program that reproduces the problem is attached as a patch.

Yep, that can easily happen:

tracecmd_read_at() calls read_event() which is:

	record = peek_event(handle, offset, cpu);
	if (record)
		record = tracecmd_read_data(handle, cpu);
	return record;

Where peek_event() caches the event record to handle->cpu_data[cpu].next.

The tracecmd_read_data() will also call tracecmd_peek_data() which if
next is set, will return that, and then set next to NULL.

A easy way to crash this is to do the following:

	CPU0				CPU1
	----				----
 tracecmd_read_at() {
  read_event() {
   peek_event() {
    tracecmd_peek_data() {
      handle->cpu_data[cpu].next = record;
    }
   }
   tracecmd_read_data() {
    tracecmd_peek_data(); [ return .next ]

					tracecmd_read_at() {
					 read_event() {
					  peek_event() {
					   tracecmd_peek_data();
					    [ return .next ]
					  }
					  tracecmd_read_data() {
					   tracecmd_peek_data() {

					    if (cpu_data[cpu].next) {
    record = cpu_data[cpu].next;
    cpu_data[cpu].next = NULL;
						[ .next is now NULL ]
					      record = cpu_data[cpu].next;
					      if (!record->data)

						[ SEGFAULT! ]


There's a few ways to solve this. We could slap mutexes all over the
code, which would slow things down and be a mess.

Or, what may be a bit more complex for threads, we could make a
tracecmd_dup() function that will clone the necessary data. Just like
dup() does for file descriptors.

new_handle = tracecmd_dup(handle);

And have the threads use their own handle. And the handle should have
its own indexes (like cpu_data and such).

They could share data (with a ref count) and then when all is done just
free it normally. The ref counts will be decremented, and when they hit
zero it will be free.

Hmm, we may need a mutex to protect the counters or if there are atomic
counters in userspace, then use them. Doing a quick search, there
appears to be some atomic counters that we can use.

-- Steve
