Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE0A537E4
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 08:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C5A42F4;
	Fri, 12 Jan 2024 00:40:44 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.77.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EE1CE3F64C;
	Fri, 12 Jan 2024 00:39:56 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH 1/5] trace-cmd: split: Small fixes
Date: Fri, 12 Jan 2024 09:39:41 +0100
Message-Id: <20240112083945.1361293-2-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240112083945.1361293-1-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Small fixes:
- Remove a useless assignment to 'current' variable.
- Fix returned type of parse_file()

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 4fda7813..6ccda2fc 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -347,11 +347,12 @@ static int parse_cpu(struct tracecmd_input *handle,
 	return 0;
 }
 
-static double parse_file(struct tracecmd_input *handle,
-			 const char *output_file,
-			 unsigned long long start,
-			 unsigned long long end, int percpu, int only_cpu,
-			 int count, enum split_types type)
+static unsigned long long parse_file(struct tracecmd_input *handle,
+				     const char *output_file,
+				     unsigned long long start,
+				     unsigned long long end, int percpu,
+				     int only_cpu, int count,
+				     enum split_types type)
 {
 	unsigned long long current;
 	struct tracecmd_output *ohandle;
@@ -551,7 +552,6 @@ void trace_split (int argc, char **argv)
 		strcat(output, ".1");
 	}
 
-	current = start_ns;
 	output_file = malloc(strlen(output) + 50);
 	if (!output_file)
 		die("Failed to allocate for %s", output);
-- 
2.25.1

