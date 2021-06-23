Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DC1C4743C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 18:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21AD611AC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 18:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWSnJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 14:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWSnI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 14:43:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E007B61185;
        Wed, 23 Jun 2021 18:40:50 +0000 (UTC)
Date:   Wed, 23 Jun 2021 14:40:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [RFC] Man page for trace-cmd-v7.dat
Message-ID: <20210623144049.47c2ca01@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ The below is a rough draft of what the new trace.dat version 7 data file
  might look like. ]

TRACE-CMD-v7.DAT(5)
===================

NAME
----
trace-cmd-v7.dat - trace-cmd file format (version 7)

SYNOPSIS
--------
*trace-cmd.dat* ignore

DESCRIPTION
-----------
The trace-cmd(1) utility produces a "trace.dat" file. The file may also
be named anything depending if the user specifies a different output name,
but it must have a certain binary format. The file is used
by trace-cmd to save kernel traces into it and be able to extract
the trace from it at a later point (see *trace-cmd-report(1)*).


INITIAL FORMAT
--------------

  The first three bytes contain the magic value:

     0x17 0x08  0x44

  The next 7 bytes contain the characters:

     "tracing"

  The next set of characters contain a null '\0' terminated string
  that contains the version of the file (for example):

     "7\0"

  The next 1 byte contains the flags for the file endianess:

     0 = little endian
     1 = big endian

  The next byte contains the number of bytes per "long" value:

     4 - 32-bit long values
     8 - 64-bit long values

  Note: This is the long size of the target's userspace. Not the
  kernel space size.

  [ Now all numbers are written in file defined endianess. ]

  The next set of characters contain a null '\0' terminating string
  that contain the compression type.

  "none\0", if the file does not have any compression algorithm in it.
  "zlib\0", if it uses the zlib compression.

  The next set of characters contain a null '\0' terminating string
  that contain the version of compression that is used.

  Note, the "none\0" compression will simply have a single null character "\0".

    ie. For compression type and version: "none\0\0"

  The next 8 bytes is the file offset to the "Options" section that defines
  where all other sections are located, which may exist anywhere
  in the file.

OPTIONS SECTION
---------------

  The options sections starts with the following format:

    8 bytes - size in bytes of this options sections

  The array of options in this section

  Each element of the array consists of:

    2 bytes - option identifier
    4 bytes - option size

  See OPTION TYPES for information on each option.

  The option section ends with the option TRACE_OPTION_DONE, which is of
  the following format:

     2 bytes - 00 00 - (TRACE_OPTION_DONE)
     4 bytes - 00 08 - (size == 8)
     8 bytes - Either zero, which means there's no more options.
               Or a file offset to another OPTION SECTION array, that
               has the same format as this section.

  The data of the section starts immediately after the above header.


SECTION FORMAT
--------------

  All other parts of the trace.dat file will have a pointer to it
  from the OPTION SECTION and defined by the OPTION TYPE. But they also
  will start with the following:

    2 bytes - Type of section (this will be the same as the option type)
    2 bytes - Flags - currently bit zero will define if the section is
              compressed or not.
    8 bytes - The size of the section in the file.
    8 bytes - The size of the section when uncompressed.
              If it is not compressed, then it will be equal
              to the size of the section in the file.

OPTION TYPES
------------

  0	TRACECMD_OPTION_DONE

        Defines the end of the option section, or if the next 8 bytes are
	other than zero, defines the offset in the file that starts another
	option section.

  1	TRACECMD_OPTION_DATE

	String defining an offset to add to the time stamps in microseconds.
	Starts with 0x.

  2	TRACECMD_OPTION_CPUSTAT

	A string defining the stats of the CPU buffer at the end of the trace.

  3	TRACECMD_OPTION_BUFFER

	String containing the name of the buffer instance, "\0" if it is the top level buffer.
	8 bytes that point to where an instance buffer exists

  4	TRACECMD_OPTION_TRACECLOCK

	No size. If exists, sets the "use_trace_clock" option of the trace-cmd handle.

  5	TRACECMD_OPTION_UNAME

	String containing the "uname" of the system that was recorded on.

  6	TRACECMD_OPTION_HOOK

	The string used for *trace-cmd record -H string*, is saved here.

  7	TRACECMD_OPTION_OFFSET

	Similar to TRACECMD_OPTION_DATE, but just add an offset to
	the timestamps. The format is a number as an ASCII string.

  8	TRACECMD_OPTION_CPUCOUNT

	4 byte integer representing the number of CPUs for the current buffer.

  9	TRACECMD_OPTION_VERSION

	A nul terminated string showing the version of trace-cmd that was used
	to record the trace.dat file.

  10	TRACECMD_OPTION_PROCMAPS

	A string containing the /proc/$PID/maps file of the processes being recorded.

  11	TRACECMD_OPTION_TRACEID

	8 byte number representing a unique identifier for the trace data.

  12	TRACECMD_OPTION_TIME_SHIFT

	8 byte number holding the trace session identifier
	4 byte number for the protocol flags
	4 byte number holding the CPU count
	Array of size the previous CPU count
	- 4 bytes holding the count of timestamp offsets
	- array of 8 byte numbers holding the above count of timestamps when offsets were calculated
	- array of 8 byte numbers holding the above count of timestamp offsets
	- array of 8 byte numbers holding the above count of timestamp scaling ratios.

  13	TRACECMD_OPTION_GUEST

	Null terminated string holding the guest name
	8 byte number of the guest trace identifier of its tracing data
	4 bytes holding the CPU count of the guest
	Array of size the previous CPU count
	- 4 byte guest virtual CPU id
	- 4 byte host PID representing the guest virtual CPU

  14	TRACECMD_OPTION_TSC2NSEC

	4 byte timestamp multiplier
	4 byte timestamp shift
	4 byte timestamp offset

  15	TRACECMD_OPTION_LATENCY

	8 byte offset of the file to a section that holds the string context of the latency trace output.

  16	TRACECMD_OPTION_HEADER_SECTION

	8 byte offset of where the header section is located
	(See HEADER INFO FORMAT)

  17	TRACECMD_OPTION_FTRACE_EVENTS

	8 byte offset of where the ftrace event section is located
	(See FTRACE EVENT FORMATS)

  18	TRACECMD_OPTION_EVENT_FORMATS

	8 byte offset of where the event format section is located
	(See EVENT FORMATS)

  19	TRACECMD_OPTION_KALLSYMS

	8 byte offset of where the kallsyms format section is located
	(See KALLSYMS INFORMATION)

  20	TRACECMD_OPTION_PRINTK

	8 byte offset of where the trace_printk format section is located
	(See TRACE_PRINTK INFORMATION)

  21	TRACECMD_OPTION_CMDLINES

	8 byte offset of where the process information section is located.
	(See PROCESS INFORMATION)


HEADER INFO FORMAT
------------------

  Directly after the initial format comes information about the
  trace headers recorded from the target box.

  The next 12 bytes contain the string:

    "header_page\0"

  The next 8 bytes are a 64-bit word containing the size of the
  page header information stored next.

  The next set of data is of the size read from the previous 8 bytes,
  and contains the data retrieved from debugfs/tracing/events/header_page.

  Note: The size of the second field \fBcommit\fR contains the target
  kernel long size. For example:

  field: local_t commit;	offset:8;	\fBsize:8;\fR	signed:1;

  shows the kernel has a 64-bit long.

  The next 13 bytes contain the string:

  "header_event\0"

  The next 8 bytes are a 64-bit word containing the size of the
  event header information stored next.

  The next set of data is of the size read from the previous 8 bytes
  and contains the data retrieved from debugfs/tracing/events/header_event.

  This data allows the trace-cmd tool to know if the ring buffer format
  of the kernel made any changes.

FTRACE EVENT FORMATS
--------------------

  Directly after the header information comes the information about
  the Ftrace specific events. These are the events used by the Ftrace plugins
  and are not enabled by the event tracing.

  The next 4 bytes contain a 32-bit word of the number of Ftrace event
  format files that are stored in the file.

  For the number of times defined by the previous 4 bytes is the
  following:

  8 bytes for the size of the Ftrace event format file.

  The Ftrace event format file copied from the target machine:
  debugfs/tracing/events/ftrace/<event>/format

EVENT FORMATS
-------------

  Directly after the Ftrace formats comes the information about
  the event layout.

  The next 4 bytes are a 32-bit word containing the number of
  event systems that are stored in the file. These are the
  directories in debugfs/tracing/events excluding the \fBftrace\fR
  directory.

  For the number of times defined by the previous 4 bytes is the
  following:

  A null-terminated string containing the system name.

  4 bytes containing a 32-bit word containing the number
  of events within the system.

  For the number of times defined in the previous 4 bytes is the
  following:

  8 bytes for the size of the event format file.

  The event format file copied from the target machine:
  debugfs/tracing/events/<system>/<event>/format

KALLSYMS INFORMATION
--------------------

  Directly after the event formats comes the information of the mapping
  of function addresses to the function names.

  The next 4 bytes are a 32-bit word containing the size of the
  data holding the function mappings.

  The next set of data is of the size defined by the previous 4 bytes
  and contains the information from the target machine's file:
  /proc/kallsyms


TRACE_PRINTK INFORMATION
------------------------

  If a developer used trace_printk() within the kernel, it may
  store the format string outside the ring buffer.
  This information can be found in:
  debugfs/tracing/printk_formats

  The next 4 bytes are a 32-bit word containing the size of the
  data holding the printk formats.

  The next set of data is of the size defined by the previous 4 bytes
  and contains the information from debugfs/tracing/printk_formats.


PROCESS INFORMATION
-------------------

  Directly after the trace_printk formats comes the information mapping
  a PID to a process name.

  The next 8 bytes contain a 64-bit word that holds the size of the
  data mapping the PID to a process name.

  The next set of data is of the size defined by the previous 8 bytes
  and contains the information from debugfs/tracing/saved_cmdlines.


CPU DATA
--------

  The CPU data is located in the part of the file that is specified
  in the end of the header. Padding is placed between the header and
  the CPU data, placing the CPU data at a page aligned (target page) position
  in the file.

  This data is copied directly from the Ftrace ring buffer and is of the
  same format as the ring buffer specified by the event header files
  loaded in the header format file.

  The trace-cmd tool will try to \fBmmap(2)\fR the data page by page with the
  target's page size if possible. If it fails to mmap, it will just read the
  data instead.

SEE ALSO
--------
trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
trace-cmd-split(1), trace-cmd-list(1), trace-cmd-listen(1),
trace-cmd.dat(5)

AUTHOR
------
Written by Steven Rostedt, <rostedt@goodmis.org>

RESOURCES
---------
https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/

COPYING
-------
Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
the terms of the GNU Public License (GPL).

