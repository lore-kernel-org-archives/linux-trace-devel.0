Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BED7E574
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909111; cv=none; b=fJlCKlw80n9Yod/UTSs1c+a+aqvQ4i72OX/nkl3VNvVVvkgk2G43I2SBm1TTfYM1+JS/nsQRg7/xOAcAweFIZHHtWHyxeY0ritR35v++yvtChmNMxtZJkpql0L0/CoOZqprQVErxb/KkPudIYORoL13YqeLxUG3F45SWCXRcfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909111; c=relaxed/simple;
	bh=Vaac8EnoeanM/QhzlqKu+YL2y1e0ksBhKZV5ROrzMIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hq2+zRZPjzLOtKuuz7sepkw3DJk1f9bKVex84hgBrRRitmgo5hAXWwQTE7VN4ucmgi+O/+UdMhTaDVY0VjjIBeM7vs1RC9yXCuRAMV/xR028LSRseeeCl3T/53mK15cB5DJQu+EI70tMuVU8A9vUulPFJbKjLuGuEGBGwNcATyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 119D7168F;
	Mon, 14 Oct 2024 05:32:19 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D8EE43F71E;
	Mon, 14 Oct 2024 05:31:48 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 4/4] trace-cmd reset: Add bash tab completion for -B and -k
Date: Mon, 14 Oct 2024 13:31:36 +0100
Message-Id: <20241014123136.3890807-5-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241014123136.3890807-1-metin.kaya@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the placeholder for tab completion of "trace-cmd reset".

Apparently trace-cmd.bash already has support for instance buffers
lookup (which is show_instances()). Employ it for -B option.

Regarding -k option, show the list of dynamic event types to ease
trace-cmd user's job.

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 tracecmd/trace-cmd.bash | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 66bd6f4b..01a75578 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -215,6 +215,33 @@ __trace_cmd_report_complete()
     esac
 }
 
+dynevent_options()
+{
+    local cur="$1"
+    local opts=("kprobe" "kretprobe" "uprobe" "uretprobe" "eprobe" "synth" "all")
+    COMPREPLY=( $(compgen -W "${opts[*]}" -- "${cur}") )
+}
+
+__trace_cmd_reset_complete()
+{
+    local prev=$1
+    local cur=$2
+    shift 2
+    local words=("$@")
+
+    case "$prev" in
+        -B)
+            show_instances "$cur"
+            ;;
+        -k)
+            dynevent_options "$cur"
+            ;;
+        *)
+            cmd_options reset "$cur"
+            ;;
+    esac
+}
+
 __trace_cmd_dump_complete()
 {
     local prev=$1
@@ -329,6 +356,10 @@ _trace_cmd_complete()
 	    __trace_cmd_report_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
+	reset)
+	    __trace_cmd_reset_complete "${prev}" "${cur}" "${words[@]}"
+	    return 0
+	    ;;
 	dump)
 	    __trace_cmd_dump_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
-- 
2.34.1

