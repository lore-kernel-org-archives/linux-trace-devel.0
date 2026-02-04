Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BD0135A53
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770168135; cv=none; b=Y4/ZMYFU1YnT+OUF6woD2yQ66ZUtQDLX8Q18aDec5P6yG+uWsuHrsHRjV87AphIqO7hvhhdXzeFWz+Kv4jRoOItTTH8ZQ2VsTHCjETF6giQ9eVyGagNgSXW+pRrImzOoE2Og0JmwnuHD4n10gwHRuWSTZLFFw9iOvIbxpHHEtkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770168135; c=relaxed/simple;
	bh=zj+osKTTcsXIoj9HhkrV8iFhj8BgVU4+Odyty/LV2mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqSlTIcmwc5ivqmAqVToBpGqoN1/I3rM8oeFKYlOamYPhBeiVViImHlImVlVlXaCjhbFCLfN+9OXzT9xOcZwLjckB/6wnNCvRGGqYPFdQzPpUW6u6DzyuXkpMISGpq+/P+KYbxH3rOZTQwj6t/HwzRyQeK+leSFoVFY9vB8HGzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353BDC2BC86;
	Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRbR-00000008xa4-13rg;
	Tue, 03 Feb 2026 20:22:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd record: Handle persistent ring buffers
Date: Tue,  3 Feb 2026 20:18:04 -0500
Message-ID: <20260204012244.2135465-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that a ring buffer instance can be from a previous boot, allow trace-cmd
to be able to read its content and still get the function names from the
addresses.

If a persistent ring buffer is from a previous boot, it will have a
"last_boot_info" file. This contains the address of the _text section of the
core kernel as well as where all the modules were loaded. This can be used
to calculate the addresses in the previous boot ring buffer to the addresses
in the current kallsyms to find out the name of the function an address
belongs to.

Also if the last_boot_info file exists, the /proc/modules file is read. This
is because functions in modules needs to have its address calculated from
where its module was loaded in the previous boot to where it is loaded in
the current boot. The last_boot_info contains the addresses of the modules
of the previous boot, and /proc/modules contains the addresses of the
modules from the current boot. With both the addresses of functions in
modules can be converted to the corresponding address in kallsyms.

Steven Rostedt (Google) (2):
  trace-cmd record: Handle last_boot_info file
  trace-cmd record: Add section for /proc/modules

 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 31 +++++++++--
 .../include/private/trace-cmd-private.h       |  3 ++
 lib/trace-cmd/trace-ftrace.c                  |  4 +-
 lib/trace-cmd/trace-input.c                   | 31 +++++++++++
 lib/trace-cmd/trace-output.c                  | 32 ++++++++++++
 tracecmd/include/trace-local.h                |  2 +
 tracecmd/trace-dump.c                         | 32 ++++++++++++
 tracecmd/trace-record.c                       | 52 +++++++++++++++++++
 8 files changed, 180 insertions(+), 7 deletions(-)

-- 
2.51.0

