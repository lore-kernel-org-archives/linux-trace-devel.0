Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6756C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC5A2465A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVRf4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:35:56 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35489 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRf4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:35:56 -0500
Received: by mail-qk1-f194.google.com with SMTP id z76so546614qka.2;
        Wed, 22 Jan 2020 09:35:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=4MN93WzjZySgUayronir/rhlf1dheXA8RnBQG6ieOEA=;
        b=dgBB0X0kh6djLFfFTTMwvnwbBIfKCk0m4qzW9ZAeXqQXFPPtWWQPq6dsungOOypABb
         LCOwa30oUF+EVvZRkyiwsUrVpUDa9gpeNSC//hI2IEm3Tgz9jvGd31aehQBrAjUBbsPq
         XT1RtAEKhj5NGgOx+XCyNfj/P8cF3eP1dtHWAOnNemCToxsCy6VNMAq1BaMTD8Phq7++
         /8usiczw4af2fyKWEV4ipT0W9BTA695b8Y8lBXdIzEXBe4VHYXZHzHZZxfqhKOavil+Q
         QPxAGtNFesWM7GplS02Ljk57M5jtRphMVxYjRgrF9VQTkwRhZ0Cwhf0cbsYup4MnZ+ay
         4nBg==
X-Gm-Message-State: APjAAAX/ahhKeZbNZHqr89BO7krwIXcW97Ha3UJkuBDD8KL/3Yb3XA1A
        z8UvRl7tJuiGhgwF/KwWDN1PX7lE
X-Google-Smtp-Source: APXvYqxIHDDJk8yUGDNe55F6OX51cAlYMCDIL24+1aRn3GxAWoWVthpWtWv7Rr7N1a+E/U+7JbCpIQ==
X-Received: by 2002:a37:e317:: with SMTP id y23mr11424114qki.431.1579714554067;
        Wed, 22 Jan 2020 09:35:54 -0800 (PST)
Received: from gmail.com (192-222-181-218.qc.cable.ebox.net. [192.222.181.218])
        by smtp.gmail.com with ESMTPSA id j185sm19138888qkc.96.2020.01.22.09.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 09:35:53 -0800 (PST)
Date:   Wed, 22 Jan 2020 12:35:51 -0500
From:   =?iso-8859-1?Q?J=E9r=E9mie?= Galarneau 
        <jeremie.galarneau@efficios.com>
To:     lttng-dev@lists.lttng.org,
        diamon-discuss@lists.linuxfoundation.org,
        linux-trace-users@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: [RELEASE] Babeltrace 2.0.0
Message-ID: <20200122173551.GA119719@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello people!

This is it: the day you've been waiting for has finally arrived.

Today we're releasing Babeltrace 2.0 “Amqui”! 🥳

Amqui [1] (/ɒmkwiː/) is a town in eastern Québec [2], Canada, at the
base of the Gaspé peninsula [3] in Bas-Saint-Laurent [4].

Located at the confluence of the Humqui and Matapédia [5] Rivers, its
proximity to woodlands makes it a great destination for outdoor
activities such as camping, hiking, and mountain biking.

By the way, Babeltrace has a new dedicated domain name:
`babeltrace.org`.

NOTE: An HTML version of this announcement is available at
<https://diamon.org/babeltrace/docs/release-notes/babeltrace-2.0.0-release-notes.html>.

Background
==========
Just a few words about why Babeltrace 2 took about five years to
complete.

First, let us clarify that from day one, one of the most important
imperatives of the project was **long-term stability**: we wanted
Babeltrace 2 to last for a long time and for its library's API to become
a well-known reference in the trace processing territory, a bit like
Libxml2 [6] has had major version 2 for about 20 years. All the other
Babeltrace 2 parts depend on the library's C API [7]: the command-line
interface [8] (CLI), the plugins, and the Python bindings.

So, as we needed to modify the library, CLI, and plugins to adapt to new
requirements during the development phase, we postponed the release so
as not to have to release Babeltrace 3 a year after and Babeltrace 4
another year after.

Second, the scope and requirements of the project evolved. Because there
were at most two developers working on Babeltrace 2 at the same time
during its first years, the project took enough time to develop for new
ideas to emerge and translate into changes, sometimes significant, to
the project's modules.

For example, the very first requirement was for the libbabeltrace2 API
to use the same objects as Babeltrace 1's CTF writer API. We put a _lot_
of effort backfitting new concepts into the CTF writer API and making
sure not to break existing user code. But in the end, we realized that
this condition was too limiting and that we had to split the APIs
completely to have the freedom to introduce all the features we wanted.

When the API finally met our needs feature-wise in 2018, we measured and
found that a simple CTF-to-text conversion task with Babeltrace 2 was
approximately 23 times slower than the equivalent with Babeltrace 1!
Hence we entered an optimization phase [9] in which we had to redefine
core concepts of the library (for example, introduce _unique_ objects to
create object pools [10]) so that, today, Babeltrace 2's performance is
comparable to Babeltrace 1's [11].

Revamping the C API to optimize the library means we had to readapt the
CLI, plugins, and Python bindings. We spent the beginning of 2019
synchronizing the project's parts, but also improving and uplifting the
test suite and fixing a lot of lingering bugs.

The last few months were invested in writing a complete C API
documentation [7] and in more bug fixes, tests, and build system
improvements.

Today ends this journey to Babeltrace 2.0. It's been a long one, but we
made it. All the next releases of Babeltrace 2 will be minor ones for
the foreseeable future, never breaking the library's API.

Babeltrace 2 is:

* 120,000 lines of C.
* 7000 lines of Python.
* 21,000 tests.
* 30,000 lines of C API documentation.
* 24 manual pages

We hope you enjoy using our software as much as we enjoyed making and
refining it over the last years.

What's new since Babeltrace 1?
==============================
The Babeltrace 2 project is completely independent from Babeltrace 1. In
fact, you can install both on the same system as they share no common
files. We only made sure to keep the `babeltrace2` CLI [8] tool backward
compatible with the original `babeltrace` tool [12].

See `babeltrace2-intro(7)` [13] to learn more about Babeltrace 2.

General:
    * Full plugin support: any user can distribute a Babeltrace 2 plugin
      and, as long as libbabeltrace2 finds it, any application linked to
      libbabeltrace2 can load it and use it.

      Plugins are not just trace format encoders and decoders: they
      package source, filter, and sink component classes so that you can
      connect specialized, reusable components together in a trace
      processing graph to create a customized trace conversion or
      analysis device.

      This modular strategy is much like how the FFmpeg [14],
      GStreamer [15], and DirectShow [16] projects approach media stream
      processing.

    * All the parts of the Babeltrace 2 project run on the major
      operating systems, including Linux, macOS, and Windows.

    * Some component classes, such as `sink.text.pretty` [17] (similar
      to the `text` output format of the `babeltrace` CLI [12]) and
      `sink.text.details` [18], can write color codes to the standard
      output when it's connected to a color-enabled terminal.

      The Babeltrace 2 log, printed to the standard output, can also be
      colorized.

Command-line interface:
    * Whereas you can convert traces from one format to another with
      Babeltrace 1's CLI tool, `babeltrace` [12], you can also execute a
      custom trace manipulation task with `babeltrace2` [8] thanks to
      its `run` [19] command.

    * The `convert` [20] command features an automatic source component
      discovery algorithm to find the best suited components to create
      for a given non-option argument (file or directory path, or custom
      string like an LTTng live [21] URL).

      For example:

          $ babeltrace2 /path/to/ctf/trace

          $ babeltrace2 net://localhost/host/myhost/my-session

CTF input/output [22]:
    * The `source.ctf.fs` [23] component class, which is more or less
      the equivalent of Babeltrace 1's `ctf` input format, has features
      not found in Babeltrace 1:

      * The component handles many trace quirks [24] which are the
        results of known tracer bugs (which are fixed today) and corner
        cases in LTTng-UST, LTTng-modules, and barectf [25], making it
        possible to decode malformed packets.

      * The component merges CTF traces sharing the same UUID into a
        single, logical trace [26].

        This feature supports LTTng 2.11's tracing session rotation [27]
        trace chunks.

    * With a `sink.ctf.fs` [28] component, you can create CTF traces on
      the file system.

      With the `babeltrace2` tool, you can use the `--output-format=ctf`
      and `--output` options to create an implicit `sink.ctf.fs`
      component.

      For example:

          $ babeltrace2 /path/to/input/trace --output-format=ctf \
                                             --output=trace-dir

LTTng live [21] input:
    Babeltrace 1's `babeltrace` command [12] exits successfully when it
    cannot find an LTTng live (`--input-format=lttng-live` option)
    tracing session.

    The `session-not-found-action` [29] initialization parameter
    controls what a `source.ctf.lttng-live` [30] message iterator does
    when it cannot find the remote tracing session:

    * If the action is `end`, the message iterator does like
      `babeltrace` and simply ends successfully.

    * If the action is `continue` (the default), the message iterator
      never ends: it keeps on trying until the tracing session exists,
      indeed “subscribing” to the session.

Library:
    * libbabeltrace2 shares nothing with libbabeltrace.

      The Babeltrace 2 library C API [7] has features such as:

      * A single header file.
      * Function precondition and postcondition checking.
      * Object-oriented model with shared and unique objects.
      * Strict C typing and `const` correctness.
      * User-extensible classes.
      * Rich, thread-safe error reporting.
      * Per-component and per-subsystem logging levels.
      * Trace intermediate representation (IR) objects to make the API
        trace-format-agnostic.
      * A versioned protocol for the exchange of messages between
        components to enable forward and backward compatibility.

    * You can build the library in _developer mode_ to enable an
      extensive set of function precondition and postcondition checks.

      The developer mode can help detect programming errors early when
      you develop a Babeltrace 2 plugin or an application using
      libbabeltrace2.

      See the project's README [31] for build-time requirements and
      detailed build instructions.

Python 3 bindings:
    * The new `bt2` package offers all the functionality of
      libbabeltrace2 and even more through a brand new, Pythonic
      programming interface.

    * With the `bt2` package, you can load existing plugins and create a
      trace processing graph, but also create Babeltrace 2 plugins.

      libbabeltrace2 can load both shared object and Python plugins.

    * What has the `const` qualifier in libbabeltrace2 has a dedicated
      constant type in the `bt2` package so that methods to modify it
      simply do not exist. This can help catch programming errors.

      For example, when you create an event message, you get a
      `bt2._EventMessage` object. When you consume an event message, you
      get an immutable `bt2._EventMessageConst` object. Both objects
      wrap the same C `bt_event *` (and `const bt_event *`) object.

What's new since Babeltrace 2.0.0-rc4?
======================================

Improvements
~~~~~~~~~~~~
General:
    * Hide private symbols.

    * Add a mechanism to add extra information (name, description, and
      names of applied patches) to a custom build's version.

      See `1f316595`.

Command-line interface:
    Print full version, including the release's name and name
    description, the Git revision's description, and the extra
    information, with the `--version` option.

    See `72fa419d`.

Documentation:
    Write a comprehensive Babeltrace 2 library C API documentation [7].

    See `7704a0af`.

Library:
    * Remove the `bt_packet_context_field` API (not needed anymore).

      See `9b98c3bf`.

    * Standardize variant field option function names.

      See `7e0b3e01`.

    * Graph API: remove “ports connected” listeners (not needed
      anymore).

      See `d9d764cc`.

    * Graph API: remove the “listener removed” callbacks (not needed
      anymore).

      See `fecbdb3e`.

    * Remove `bt_graph_interrupt()`; use the new
      `bt_graph_borrow_default_interrupter()` function instead.

      See `f09b3ae9`.

    * Remove `bt_query_executor_interrupt()`; use the new
      `bt_query_executor_borrow_default_interrupter()` function instead.

      See `d9a20b20`.

    * Add the _message iterator class_ concept.

      Instead of having an implicit message iterator class within source
      and filter component classes, make its creation explicit and pass
      it to `bt_component_class_source_create()` and
      `bt_component_class_filter_create()`.

      See `68e2deed`, `8e1fe2a4`, and `f615b250`.

    * Rename `BT_PLUGIN_INITIALIZE()` to `BT_PLUGIN_INITIALIZE_FUNC()`
      and `BT_PLUGIN_FINALIZE()` to `BT_PLUGIN_FINALIZE_FUNC()`.

      See `1906e012`.

    * For many functions of the graph and component APIs, return a
      _borrowed_ reference of an added object instead of a new
      reference.

      See `246d5223`.

    * Rename
      `bt_message_message_iterator_inactivity_borrow_default_clock_snapshot_const()`
      to
      `bt_message_message_iterator_inactivity_borrow_clock_snapshot_const()`.

      See `62988c56`.

    * Rename `bt_version_get_extra()` to
      `bt_version_get_development_stage()`.

      See `19e20ba9`.

    * Add the following functions to get more information about the
      library's version:

      * `bt_version_get_vcs_revision_description()`
      * `bt_version_get_name()`
      * `bt_version_get_name_description()`
      * `bt_version_get_extra_name()`
      * `bt_version_get_extra_description()`
      * `bt_version_get_extra_patch_names()`

      See `2491e1b5`, `58df4c80`, and `a0446fa8`.

Python bindings:
    * Adapt to the library changes above.

    * Make `bt2.Graph.add_*_listener()` return `None`.

      See `d9d764cc`.

    * Reverse the order of the printed causes in `bt2._Error.__str__()`
      to match what the CLI does.

      See `701698c8`.

`source.ctf.fs` component class [23]:
    Sort the paths of the data stream files to handle so that the output
    port order is predictable (for debugging purposes).

    See `18118efb`.

Notable bug fixes
~~~~~~~~~~~~~~~~~
Command-line interface:
    Print error causes in all error paths.

    See `f2ff3e07`.

Python bindings:
    * Fix shared reference issues in listener handles.

      See `d4024c86`.

    * Don't print previous error causes in causes created from
      `bt2._Error`.

      See `b53cd768`.

What's next?
============
The current road map includes:

* Make it easier to create an efficient filter message iterator which
  needs to modify or augment event messages.

  Currently, if you need to modify an event message, considering that
  you cannot change an event class once you use it, you need to create a
  new event class, which means you also need to create a new stream
  class and a new trace class. You also need to copy all the metadata
  and data objects you don't alter. This is what
  `filter.lttng-utils.debug-info` [32] does.

  We do realize that trace-transforming filter message iterators
  represent an important Babeltrace 2 use case. While it's possible to
  write one for Babeltrace 2.0, it is cumbersome to do and the result is
  not as performant as we'd like. We decided to release Babeltrace 2 now
  and reserve improvements to this part of the library for a future
  minor release.

* Add a filter component class to drop messages (like events) based on a
  filter expression, similar to the `--filter` option [33] of the
  `lttng` command.

* Make the `ctf` [34] plugin's component classes support CTF 2, the
  upcoming major revision of the Common Trace Format [22].

* Optimize specific project component classes, especially
  `source.ctf.fs` [23], `source.ctf.lttng-live` [30], and
  `filter.utils.muxer` [35].

  For `source.ctf.fs`, implement the “seek ns from origin” method using
  the packet indexes to make a message iterator seek a specific time
  faster.

== Important links

Important links
===============
Babeltrace 2.0.0 tarball:
    https://www.efficios.com/files/babeltrace/babeltrace-2.0.0.tar.bz2

Babeltrace website:
    https://diamon.org/babeltrace

Mailing list (for support and development):
    `lttng-dev@lists.lttng.org`

IRC channel:
    `#lttng` on `irc.oftc.net`

Git repository:
    https://bugs.lttng.org/projects/babeltrace

GitHub project:
    https://github.com/efficios/babeltrace

Continuous integration:
    https://ci.lttng.org/view/Babeltrace/

Code review:
    https://review.lttng.org/q/project:babeltrace

References
==========
[1]: https://en.wikipedia.org/wiki/Amqui
[2]: https://en.wikipedia.org/wiki/Quebec
[3]: https://en.wikipedia.org/wiki/Gasp%C3%A9_Peninsula
[4]: https://en.wikipedia.org/wiki/Bas-Saint-Laurent
[5]: https://en.wikipedia.org/wiki/Matapedia_River
[6]: http://www.xmlsoft.org/
[7]: https://babeltrace.org/docs/v2.0/libbabeltrace2/
[8]: https://babeltrace.org/docs/v2.0/man1/babeltrace2.1/
[9]: https://tracingsummit.org/ts/2018/files/Tracingsummit2018-babeltrace2-proulx.pdf
[10]: https://en.wikipedia.org/wiki/Object_pool_pattern
[11]: https://babeltrace.org/docs/release-notes/babeltrace-benchmark-2020-01-20.pdf
[12]: http://man7.org/linux/man-pages/man1/babeltrace.1.html
[13]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-intro.7
[14]: https://www.ffmpeg.org/
[15]: https://gstreamer.freedesktop.org/
[16]: https://en.wikipedia.org/wiki/DirectShow
[17]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-sink.text.pretty.7
[18]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-sink.text.details.7
[19]: https://babeltrace.org/docs/v2.0/man1/babeltrace2-run.1
[20]: https://babeltrace.org/docs/v2.0/man1/babeltrace2-convert.1
[21]: https://lttng.org/docs/#doc-lttng-live
[22]: https://diamon.org/ctf/
[23]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-source.ctf.fs.7
[24]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-source.ctf.fs.7/#doc-_trace_quirks
[25]: https://github.com/efficios/barectf
[26]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-source.ctf.fs.7/#doc-input
[27]: https://lttng.org/docs/#doc-session-rotation
[28]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-sink.ctf.fs.7
[29]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-source.ctf.lttng-live.7/#doc-param-session-not-found-action
[30]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-source.ctf.lttng-live.7
[31]: https://github.com/efficios/babeltrace/blob/stable-2.0/README.adoc
[32]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-filter.lttng-utils.debug-info.7
[33]: https://lttng.org/man/1/lttng-enable-event/v2.11/#doc-opt--filter
[34]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-plugin-ctf.7
[35]: https://babeltrace.org/docs/v2.0/man7/babeltrace2-filter.utils.muxer.7
